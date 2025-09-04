import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageCutoutProcessor {
  static Uint8List createCutout(
      Uint8List originalImageBytes,
      Uint8List maskBytes,
      ) {
    final originalImage = img.decodeImage(originalImageBytes);
    final maskImage = img.decodePng(maskBytes);

    if (originalImage != null && maskImage != null) {
      var originalWidth = originalImage.width;
      var originalHeight = originalImage.height;

      // 1. 마스크 원본 크기로 맞춤
      final resizedMask = img.copyResize(
        maskImage,
        width: originalWidth,
        height: originalHeight,
        interpolation: img.Interpolation.linear,
      );

      // 2. 바운딩 박스 찾기
      int minX = originalWidth, minY = originalHeight, maxX = 0, maxY = 0;
      bool hasValidPixel = false;

      for (int y = 0; y < originalHeight; y++) {
        for (int x = 0; x < originalWidth; x++) {
          final maskValue = img.getRed(resizedMask.getPixel(x, y));
          if (maskValue > 128) {
            hasValidPixel = true;
            if (x < minX) minX = x;
            if (y < minY) minY = y;
            if (x > maxX) maxX = x;
            if (y > maxY) maxY = y;
          }
        }
      }

      // 마스크가 비어있는 경우
      if (!hasValidPixel) {
        print('Empty mask - no valid pixels found');
        return Uint8List.fromList(img.encodePng(originalImage));
      }

      final objectWidth = maxX - minX + 1;
      final objectHeight = maxY - minY + 1;

      // 안전장치: 유효하지 않은 바운딩 박스인 경우
      if (objectWidth <= 0 || objectHeight <= 0 || minX >= originalWidth || minY >= originalHeight) {
        print('Invalid bounding box: width=$objectWidth, height=$objectHeight, minX=$minX, minY=$minY');
        // 전체 이미지를 반환
        return Uint8List.fromList(img.encodePng(originalImage));
      }

      // 3. 오브젝트 영역 잘라내기
      final cropped = img.copyCrop(originalImage,
          minX, minY, objectWidth, objectHeight);
      final croppedMask = img.copyCrop(resizedMask,
          minX, minY, objectWidth, objectHeight);

      // 4. 컷아웃 이미지 만들기
      final cutout = img.Image( objectWidth, objectHeight);
      for (int y = 0; y < objectHeight; y++) {
        for (int x = 0; x < objectWidth; x++) {
          final maskValue = img.getRed(croppedMask.getPixel(x, y));
          final pixel = cropped.getPixel(x, y);
          if (maskValue > 128) {
            cutout.setPixel(x, y, pixel);
          } else {
            cutout.setPixel(x, y, img.Color.fromRgba(0, 0, 0, 0));
          }
        }
      }

      // 캔버스 크기 지정에 따라 보더도 달라짐
      originalWidth = 512;
      originalHeight = 512;

      // 5. 오브젝트를 캔버스 80% 크기로 리사이즈
      final targetWidth = (originalWidth * 0.75).toInt();
      final targetHeight = (originalHeight * 0.75).toInt();
      final scaledCutout = img.copyResize(
        cutout,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.nearest,
      );

      // 6. 중앙에 배치
      final result = img.Image( originalWidth,  originalHeight);
      final offsetX = (originalWidth - targetWidth) ~/ 2;
      final offsetY = (originalHeight - targetHeight) ~/ 2;
      img.copyInto(result, scaledCutout, dstX: offsetX, dstY: offsetY);

      return Uint8List.fromList(img.encodePng(result));
    }

    return Uint8List.fromList([]);
  }
}
