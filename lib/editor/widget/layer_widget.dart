import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';

class LayerWidget extends StatelessWidget {
  final ImageLayer layer;
  final bool isTemplate;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(ScaleStartDetails)? onScaleStart;
  final Function(ScaleUpdateDetails)? onScaleUpdate;

  const LayerWidget({
    super.key,
    required this.layer,
    this.isTemplate = false,
    this.onTap,
    this.onDelete,
    this.onScaleStart,
    this.onScaleUpdate,
  });

  @override
  Widget build(BuildContext context) {
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
              // 메인 이미지
              Transform.scale(
                scale: layer.scale,
                child: Transform.rotate(
                  angle: layer.rotation,
                  child: Image.asset(
                    layer.imagePath,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
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
