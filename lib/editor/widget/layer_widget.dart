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
                    width: isTemplate ? 200 : 100,
                    height: isTemplate ? 200 : 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: isTemplate ? 200 : 100,
                        height: isTemplate ? 200 : 100,
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
              
              // 선택된 레이어에만 삭제 버튼 표시 (템플릿 제외)
              if (layer.isSelected && !isTemplate && onDelete != null)
                Positioned(
                  top: -10,
                  right: -10,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              
              // 선택된 레이어에 크기 조절 핸들 표시
              if (layer.isSelected)
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      color: Colors.white,
                      size: 12,
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

class LayerInfo extends StatelessWidget {
  final ImageLayer layer;
  final VoidCallback? onDelete;

  const LayerInfo({
    super.key,
    required this.layer,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: layer.isSelected ? Colors.blue[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: layer.isSelected ? Colors.blue : Colors.grey,
        ),
      ),
      child: Row(
        children: [
          // 썸네일
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              layer.imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 30,
                  height: 30,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 16),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          
          // 레이어 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  layer.id.length > 15 
                      ? '${layer.id.substring(0, 15)}...' 
                      : layer.id,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Scale: ${layer.scale.toStringAsFixed(1)}x',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          // 삭제 버튼
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, size: 16),
              color: Colors.red,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
        ],
      ),
    );
  }
}