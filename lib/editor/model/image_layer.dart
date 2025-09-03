import 'package:flutter/material.dart';

class ImageLayer {
  final String id;
  final String imagePath;
  Offset position;
  double scale;
  double rotation; // 회전 각도 (라디안)
  bool isSelected;
  
  ImageLayer({
    required this.id,
    required this.imagePath,
    this.position = const Offset(50, 50),
    this.scale = 1.0,
    this.rotation = 0.0,
    this.isSelected = false,
  });

  ImageLayer copyWith({
    String? id,
    String? imagePath,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isSelected,
  }) {
    return ImageLayer(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // 레이어를 이동시키는 메서드
  ImageLayer move(Offset delta) {
    return copyWith(position: position + delta);
  }

  // 레이어 크기를 조정하는 메서드
  ImageLayer scaleBy(double factor) {
    return copyWith(scale: (scale * factor).clamp(0.1, 5.0));
  }

  // 레이어를 회전시키는 메서드
  ImageLayer rotate(double deltaRotation) {
    return copyWith(rotation: rotation + deltaRotation);
  }

  // 레이어 선택 상태를 토글하는 메서드
  ImageLayer toggleSelection() {
    return copyWith(isSelected: !isSelected);
  }

  // 경계 박스 계산 (충돌 감지나 선택 영역 표시용)
  Rect getBounds(Size imageSize) {
    final scaledSize = imageSize * scale;
    return Rect.fromCenter(
      center: position + Offset(scaledSize.width / 2, scaledSize.height / 2),
      width: scaledSize.width,
      height: scaledSize.height,
    );
  }

  @override
  String toString() {
    return 'ImageLayer(id: $id, position: $position, scale: $scale, rotation: $rotation, selected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageLayer &&
        other.id == id &&
        other.imagePath == imagePath &&
        other.position == position &&
        other.scale == scale &&
        other.rotation == rotation &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return Object.hash(id, imagePath, position, scale, rotation, isSelected);
  }
}