import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  final double tileSize;
  final Color lightColor;
  final Color darkColor;

  CheckerboardPainter({
    this.tileSize = 20.0,
    this.lightColor = const Color(0xFFFFFFFF), // 흰색
    this.darkColor = const Color(0xFFC0C0C0),  // 연한 회색
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()..color = lightColor;
    final darkPaint = Paint()..color = darkColor;

    // 가로, 세로 타일 개수 계산
    int tilesX = (size.width / tileSize).ceil();
    int tilesY = (size.height / tileSize).ceil();

    for (int x = 0; x < tilesX; x++) {
      for (int y = 0; y < tilesY; y++) {
        // 체커보드 패턴: (x + y)가 짝수면 밝은색, 홀수면 어두운색
        final paint = (x + y) % 2 == 0 ? lightPaint : darkPaint;

        final rect = Rect.fromLTWH(
          x * tileSize,
          y * tileSize,
          tileSize,
          tileSize,
        );

        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}