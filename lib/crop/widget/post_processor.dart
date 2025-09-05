import 'package:image/image.dart' as img;
import 'dart:typed_data';

class PostProcessor {

  // 1. 가장 큰 연결 영역만 남기기 (엄지손가락 제거!)
  static Uint8List keepLargestComponent(Uint8List maskBytes) {
    final maskImage = img.decodePng(maskBytes)!;
    final width = maskImage.width;
    final height = maskImage.height;

    // 이진화
    final binaryMask = List.generate(height, (_) => List.filled(width, false));
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = maskImage.getPixel(x, y);
        final gray = pixel.r;
        binaryMask[y][x] = gray > 128; // 임계값 128
      }
    }

    // 연결 성분 찾기 (간단한 flood fill)
    final visited = List.generate(height, (_) => List.filled(width, false));
    final components = <List<List<int>>>[];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (binaryMask[y][x] && !visited[y][x]) {
          final component = <List<int>>[];
          _floodFill(binaryMask, visited, x, y, component);
          if (component.isNotEmpty) {
            components.add(component);
          }
        }
      }
    }

    if (components.isEmpty) return maskBytes;

    // 가장 큰 성분 찾기
    int maxSize = 0;
    int maxIndex = 0;
    for (int i = 0; i < components.length; i++) {
      if (components[i].length > maxSize) {
        maxSize = components[i].length;
        maxIndex = i;
      }
    }

    // 결과 이미지 생성
    final resultImage = img.Image(width: width, height: height, numChannels: 4);
    img.fill(resultImage, color: img.ColorRgba8(0, 0, 0, 0)); // 검은색으로 초기화

    // 가장 큰 성분만 흰색으로 칠하기
    for (final point in components[maxIndex]) {
      final x = point[0];
      final y = point[1];
      resultImage.setPixel(x, y, img.ColorRgb8(255, 255, 255));
    }

    return Uint8List.fromList(img.encodePng(resultImage));
  }

  // Flood fill 알고리즘 (스택 버전 - Stack Overflow 방지)
  static void _floodFill(List<List<bool>> mask, List<List<bool>> visited,
      int startX, int startY, List<List<int>> component) {
    final width = mask[0].length;
    final height = mask.length;
    final stack = <List<int>>[];

    stack.add([startX, startY]);

    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      final x = current[0];
      final y = current[1];

      // 범위 체크 및 이미 방문했거나 배경이면 skip
      if (x < 0 || x >= width || y < 0 || y >= height ||
          visited[y][x] || !mask[y][x]) {
        continue;
      }

      visited[y][x] = true;
      component.add([x, y]);

      // 8방향 이웃을 스택에 추가
      for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
          if (dx != 0 || dy != 0) {
            final newX = x + dx;
            final newY = y + dy;
            stack.add([newX, newY]);
          }
        }
      }
    }
  }

  // 2. 형태학적 연산 (노이즈 제거, 홀 메우기)
  static Uint8List morphologicalClean(Uint8List maskBytes) {
    final maskImage = img.decodePng(maskBytes)!;
    final width = maskImage.width;
    final height = maskImage.height;

    // 이진 마스크로 변환
    final binary = List.generate(height, (_) => List.filled(width, false));
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = maskImage.getPixel(x, y);
        binary[y][x] = pixel.r > 128;
      }
    }

    // Opening (침식 → 팽창) : 작은 노이즈 제거
    final eroded = _erode(binary, 1);
    final opened = _dilate(eroded, 1);

    // Closing (팽창 → 침식) : 작은 홀 메우기
    final dilated = _dilate(opened, 2);
    final closed = _erode(dilated, 2);

    // 결과 이미지 생성
    final resultImage = img.Image(width: width, height: height, numChannels: 4);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final color = closed[y][x] ?
        img.ColorRgb8(255, 255, 255) :
        img.ColorRgb8(0, 0, 0);
        resultImage.setPixel(x, y, color);
      }
    }

    return Uint8List.fromList(img.encodePng(resultImage));
  }

  // 침식 연산
  static List<List<bool>> _erode(List<List<bool>> image, int kernelSize) {
    final height = image.length;
    final width = image[0].length;
    final result = List.generate(height, (_) => List.filled(width, false));
    final radius = kernelSize ~/ 2;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool allTrue = true;

        for (int ky = -radius; ky <= radius && allTrue; ky++) {
          for (int kx = -radius; kx <= radius && allTrue; kx++) {
            final ny = y + ky;
            final nx = x + kx;

            if (ny >= 0 && ny < height && nx >= 0 && nx < width) {
              if (!image[ny][nx]) {
                allTrue = false;
              }
            } else {
              allTrue = false;
            }
          }
        }

        result[y][x] = allTrue;
      }
    }

    return result;
  }

  // 팽창 연산
  static List<List<bool>> _dilate(List<List<bool>> image, int kernelSize) {
    final height = image.length;
    final width = image[0].length;
    final result = List.generate(height, (_) => List.filled(width, false));
    final radius = kernelSize ~/ 2;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        bool anyTrue = false;

        for (int ky = -radius; ky <= radius && !anyTrue; ky++) {
          for (int kx = -radius; kx <= radius && !anyTrue; kx++) {
            final ny = y + ky;
            final nx = x + kx;

            if (ny >= 0 && ny < height && nx >= 0 && nx < width) {
              if (image[ny][nx]) {
                anyTrue = true;
              }
            }
          }
        }

        result[y][x] = anyTrue;
      }
    }

    return result;
  }

  static Uint8List keepLargestComponentSmooth(Uint8List maskBytes) {
    final maskImage = img.decodePng(maskBytes)!;
    final width = maskImage.width;
    final height = maskImage.height;

    // 이진화 (연결성 찾기용)
    final binaryMask = List.generate(height, (_) => List.filled(width, false));
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = maskImage.getPixel(x, y);
        final gray = pixel.r;
        binaryMask[y][x] = gray > 64;
      }
    }

    // 연결 성분 찾기 (동일)
    final visited = List.generate(height, (_) => List.filled(width, false));
    final components = <List<List<int>>>[];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (binaryMask[y][x] && !visited[y][x]) {
          final component = <List<int>>[];
          _floodFill(binaryMask, visited, x, y, component);
          if (component.isNotEmpty) {
            components.add(component);
          }
        }
      }
    }

    if (components.isEmpty) return maskBytes;

    // 가장 큰 성분 찾기 (동일)
    int maxSize = 0;
    int maxIndex = 0;
    for (int i = 0; i < components.length; i++) {
      if (components[i].length > maxSize) {
        maxSize = components[i].length;
        maxIndex = i;
      }
    }

    // ✅ 핵심 수정: 원본 픽셀 값 보존!
    final resultImage = img.Image(width: width, height: height, numChannels: 4);
    img.fill(resultImage, color: img.ColorRgba8(0, 0, 0, 0));

    // 가장 큰 성분만 원본 값으로 칠하기
    for (final point in components[maxIndex]) {
      final x = point[0];
      final y = point[1];

      // ✅ 원본 픽셀 값 가져오기
      final originalPixel = maskImage.getPixel(x, y);
      resultImage.setPixel(x, y, originalPixel);  // 255가 아닌 원본 값!
    }

    return Uint8List.fromList(img.encodePng(resultImage));
  }

  static Uint8List addGaussianBlur(Uint8List maskBytes, {double radius = 2.0}) {
    final maskImage = img.decodePng(maskBytes)!;
    final blurred = img.gaussianBlur(maskImage, radius: radius.round());
    return Uint8List.fromList(img.encodePng(blurred));
  }

  // 3. 전체 후처리 파이프라인
  static Uint8List processmask(Uint8List rawMask) {
    // 1단계: 형태학적 정리
    // final cleaned = morphologicalClean(rawMask);

    // 2단계: 가장 큰 성분만 남기기
    final filtered = keepLargestComponentSmooth(rawMask);
    final blurred = addGaussianBlur(filtered, radius: 3);
    return blurred;
  }
}