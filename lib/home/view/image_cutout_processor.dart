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
      final originalWidth = originalImage.width;
      final originalHeight = originalImage.height;

      final resizedMask = img.copyResize(
        maskImage,
        width: originalWidth,
        height: originalHeight,
        interpolation: img.Interpolation.linear,
      );

      final result = img.Image(originalWidth, originalHeight);

      for (int y = 0; y < originalHeight; y++) {
        for (int x = 0; x < originalWidth; x++) {
          final maskPixel = resizedMask.getPixel(x, y);
          final maskValue = img.getRed(maskPixel);
          final originalPixel = originalImage.getPixel(x, y);

          if (maskValue > 128) {
            // 마스크 영역 - 원본 픽셀 유지
            result.setPixel(x, y, originalPixel);
          } else {
            // 배경 영역 - 완전 투명
            result.setPixel(x, y, img.Color.fromRgba(0, 0, 0, 0));
          }
        }
      }

      return Uint8List.fromList(img.encodePng(result));
    }
    return Uint8List.fromList([]);
  }
}
