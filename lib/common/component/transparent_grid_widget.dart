import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/utils/checkerboard_painter.dart';

class TransparentGridWidget extends StatelessWidget {
  final Widget child;
  final double tileSize;
  final Color lightColor;
  final Color darkColor;
  final Color? backgroundColor;  // 추가
  final String? backgroundImagePath;  // 추가
  final bool isSaving; // 추가

  const TransparentGridWidget({
    super.key,
    required this.child,
    this.tileSize = 20.0,
    this.lightColor = const Color(0xFFFFFFFF),
    this.darkColor = const Color(0xFFC0C0C0),
    this.backgroundColor,  // 추가
    this.backgroundImagePath,  // 추가
    this.isSaving = false, // 기본값 false
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 처리
        Positioned.fill(
          child: _buildBackground(),
        ),
        Center(
          child: child,
        ),
      ],
    );
  }

  Widget _buildBackground() {
    // 이미지 배경이 있으면 이미지 우선
    if (backgroundImagePath != null) {
      return Image.file(
        File(backgroundImagePath!),
        fit: BoxFit.cover,
      );
    }

    // 배경색이 있으면 단색 배경
    if (backgroundColor != null && backgroundColor != Colors.transparent) {
      return Container(color: backgroundColor);
    }

    // 저장 모드면 투명 배경
    if (isSaving) {
      return Container(color: Colors.transparent);
    }

    // 둘 다 없으면 기본 체커보드
    return CustomPaint(
      painter: CheckerboardPainter(
        tileSize: tileSize,
        lightColor: lightColor,
        darkColor: darkColor,
      ),
    );
  }
}

