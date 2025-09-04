import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';

class ImageLayerWidget extends StatelessWidget {
  final ImageLayer layer;
  final bool isTemplate;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(ScaleStartDetails)? onScaleStart;
  final Function(ScaleUpdateDetails)? onScaleUpdate;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

  const ImageLayerWidget({
    super.key,
    required this.layer,
    this.isTemplate = false,
    this.onTap,
    this.onDelete,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onDragStart,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: Draggable<String>(
        data: layer.id,
        onDragStarted: onDragStart,
        onDragEnd: (details) => onDragEnd?.call(),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Transform.scale(
            scale: layer.scale,
            child: Transform.rotate(
              angle: layer.rotation,
              child: Opacity(
                opacity: 0.3,
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
          ),
        ),
        feedback: Material(
          color: Colors.transparent,
          child: Transform.scale(
            scale: layer.scale * 0.8,
            child: Transform.rotate(
              angle: layer.rotation,
              child: Opacity(
                opacity: 0.7,
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
          ),
        ),
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
      ),
    );
  }
}
