import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/editor/model/text_layer.dart';

class TextLayerWidget extends StatelessWidget {
  final TextLayer layer;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(ScaleStartDetails)? onScaleStart;
  final Function(ScaleUpdateDetails)? onScaleUpdate;

  const TextLayerWidget({
    super.key,
    required this.layer,
    this.onTap,
    this.onDelete,
    this.onScaleStart,
    this.onScaleUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (layer.isHidden) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: GestureDetector(
        onTap: onTap,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        child: Container(
          decoration: BoxDecoration(
            border: layer.isSelected 
                ? Border.all(color: Colors.blue, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              // 메인 텍스트
              Transform.scale(
                scale: layer.scale,
                child: Transform.rotate(
                  angle: layer.rotation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      layer.text,
                      style: layer.textStyle,
                      textAlign: layer.textAlign,
                    ),
                  ),
                ),
              ),
              
              // 삭제 버튼 (선택된 경우에만 표시)
              if (layer.isSelected && onDelete != null)
                Positioned(
                  top: -10,
                  right: -10,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}