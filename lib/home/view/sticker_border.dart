import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class StickerBorder {
  static Uint8List addSimpleBorder(
    Uint8List cutoutBytes,
    int borderColor, {
    int borderWidth = 5,
  }) {
    final cutoutImage = img.decodePng(cutoutBytes)!;
    final width = cutoutImage.width;
    final height = cutoutImage.height;

    // 비율 기반 테두리 두께 (예: 3%)
    final objectSize = math.max(width, height);
    final adaptiveBorderWidth = (objectSize * 0.03).round();

    // 새 이미지 캔버스
    final newWidth = width + (adaptiveBorderWidth * 2);
    final newHeight = height + (adaptiveBorderWidth * 2);
    final result = img.Image(width: newWidth, height: newHeight);

    // 투명 배경으로 초기화
    img.fill(result, color: img.ColorRgba8(0, 0, 0, 0));

    // 테두리 찾기 및 그리기
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = cutoutImage.getPixel(x, y);
        final alpha = pixel.a;

        if (alpha > 0) {
          // 얼굴 픽셀 - 원본 위치에 복사
          result.setPixel(x + borderWidth, y + borderWidth, pixel);

          // 주변에 테두리 체크
          if (_isEdgePixel(cutoutImage, x, y)) {
            _drawBorderAroundPixel(
              result,
              x + borderWidth,
              y + borderWidth,
              borderWidth,
              borderColor,
            );
          }
        }
      }
    }

    return Uint8List.fromList(img.encodePng(result));
  }

  static bool _isEdgePixel(img.Image image, int x, int y) {
    final pixel = image.getPixel(x, y);
    if (pixel.a == 0) return false;

    // 8방향 체크
    for (int dy = -1; dy <= 1; dy++) {
      for (int dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) continue;

        final nx = x + dx;
        final ny = y + dy;

        if (nx < 0 ||
            nx >= image.width ||
            ny < 0 ||
            ny >= image.height ||
            image.getPixel(nx, ny).a == 0) {
          return true;
        }
      }
    }
    return false;
  }

  static void _drawBorderAroundPixel(
    img.Image image,
    int centerX,
    int centerY,
    int borderWidth,
    int color,
  ) {
    for (int dy = -borderWidth; dy <= borderWidth; dy++) {
      for (int dx = -borderWidth; dx <= borderWidth; dx++) {
        final distance = math.sqrt(dx * dx + dy * dy);
        if (distance <= borderWidth) {
          final x = centerX + dx;
          final y = centerY + dy;
          if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
            final existing = image.getPixel(x, y);
            if (existing.a == 0) {
              image.setPixel(x, y, img.ColorRgba8((color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF, (color >> 24) & 0xFF));
            }
          }
        }
      }
    }
  }
}
