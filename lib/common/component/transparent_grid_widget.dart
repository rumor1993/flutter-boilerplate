import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/utils/checkerboard_painter.dart';

class TransparentGridWidget extends StatelessWidget {
  final Widget child;
  final double tileSize;
  final Color lightColor;
  final Color darkColor;

  const TransparentGridWidget({
    super.key,
    required this.child,
    this.tileSize = 20.0,
    this.lightColor = const Color(0xFFFFFFFF),
    this.darkColor = const Color(0xFFC0C0C0),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 체커보드 배경
        Positioned.fill(
          child: CustomPaint(
            painter: CheckerboardPainter(
              tileSize: tileSize,
              lightColor: lightColor,
              darkColor: darkColor,
            ),
          ),
        ),
        // 중앙에 배치될 이미지
        Center(
          child: child,
        ),
      ],
    );
  }
}