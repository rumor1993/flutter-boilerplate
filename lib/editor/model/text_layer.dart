import 'package:flutter/material.dart';

class TextLayer {
  final String id;
  final String text;
  Offset position;
  double scale;
  double rotation;
  bool isSelected;
  TextStyle textStyle;
  TextAlign textAlign;
  bool isHidden;
  
  TextLayer({
    required this.id,
    required this.text,
    this.position = const Offset(50, 50),
    this.scale = 1.0,
    this.rotation = 0.0,
    this.isSelected = false,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
    ),
    this.textAlign = TextAlign.center,
    this.isHidden = false,
  });

  TextLayer copyWith({
    String? id,
    String? text,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isSelected,
    TextStyle? textStyle,
    TextAlign? textAlign,
    bool? isHidden,
  }) {
    return TextLayer(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isSelected: isSelected ?? this.isSelected,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  // 레이어를 이동시키는 메서드
  TextLayer move(Offset delta) {
    return copyWith(position: position + delta);
  }

  // 레이어 크기를 조정하는 메서드
  TextLayer scaleBy(double factor) {
    return copyWith(scale: (scale * factor).clamp(0.1, 5.0));
  }

  // 레이어를 회전시키는 메서드
  TextLayer rotate(double deltaRotation) {
    return copyWith(rotation: rotation + deltaRotation);
  }

  // 레이어 선택 상태를 토글하는 메서드
  TextLayer toggleSelection() {
    return copyWith(isSelected: !isSelected);
  }

  // 텍스트 내용 변경
  TextLayer updateText(String newText) {
    return copyWith(text: newText);
  }

  // 텍스트 스타일 변경
  TextLayer changeTextStyle(TextStyle newStyle) {
    return copyWith(textStyle: newStyle);
  }

  // 텍스트 스타일 변경
  TextLayer changeTextAlign(TextAlign newAlign) {
    return copyWith(textAlign: newAlign);
  }

  TextLayer hide() => copyWith(isHidden: true);
  TextLayer show() => copyWith(isHidden: false);

  // 스케일이 적용된 TextStyle 반환
  TextStyle get scaledTextStyle {
    return textStyle.copyWith(
      fontSize: (textStyle.fontSize ?? 24.0) * scale,
    );
  }

  // 경계 박스 계산 (텍스트 크기 기반)
  Rect getBounds(Size textSize) {
    final scaledSize = textSize * scale;
    return Rect.fromCenter(
      center: position + Offset(scaledSize.width / 2, scaledSize.height / 2),
      width: scaledSize.width,
      height: scaledSize.height,
    );
  }

  @override
  String toString() {
    return 'TextLayer(id: $id, text: "$text", position: $position, scale: $scale, rotation: $rotation, selected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextLayer &&
        other.id == id &&
        other.text == text &&
        other.position == position &&
        other.scale == scale &&
        other.rotation == rotation &&
        other.isSelected == isSelected &&
        other.textStyle == textStyle &&
        other.textAlign == textAlign;
  }

  @override
  int get hashCode {
    return Object.hash(
      id, text, position, scale, rotation, isSelected, textStyle, textAlign
    );
  }
}