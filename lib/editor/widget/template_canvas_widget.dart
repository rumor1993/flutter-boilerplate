import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';
import 'package:flutter_boilerplate/editor/model/text_layer.dart';
import 'package:flutter_boilerplate/editor/widget/image_layer_widget.dart';
import 'package:flutter_boilerplate/editor/widget/text_layer_widget.dart';

class TemplateCanvasWidget extends StatefulWidget {
  final GlobalKey containerKey;
  final List<ImageLayer> imageLayers;
  final List<TextLayer> textLayers;
  final void Function(TextLayer layer) onTextLayerEdit;
  final Color? backgroundColor;
  final String? backgroundImagePath;
  final bool isSaving;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final Function(String layerId)? onLayerDelete;

  const TemplateCanvasWidget({
    super.key,
    required this.containerKey,
    required this.imageLayers,
    required this.textLayers, 
    required this.onTextLayerEdit, 
    this.backgroundColor, 
    this.backgroundImagePath, 
    required this.isSaving,
    this.onDragStart,
    this.onDragEnd,
    this.onLayerDelete,
  });

  @override
  State<TemplateCanvasWidget> createState() => _TemplateCanvasWidgetState();
}

class _TemplateCanvasWidgetState extends State<TemplateCanvasWidget> {
  // 크기 변경을 위한 필드
  final Map<String, double> _imageInitialScales = {};
  // 위치 이동을 위한 필드
  final Map<String, Offset> _imageInitialPositions = {};
  // 제스처 시작할 때의 절대 좌표
  final Map<String, Offset> _imageInitialFocalPoints = {};
  // 회전을 위한 필드
  final Map<String, double> _imageInitialRotations = {}; // 회전 초기값 추가!

  final Map<String, double> _textInitialScales = {};
  final Map<String, Offset> _textInitialPositions = {};
  final Map<String, Offset> _textInitialFocalPoints = {};
  final Map<String, double> _textInitialRotations = {}; // 회전 초기값 추가!


  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.containerKey,
      child: Stack(
        children: [
          TransparentGridWidget(
            tileSize: 12.5,
            lightColor: Color(0xFF262626),
            darkColor: Color(0xFF1F1F1F),
            backgroundColor: widget.backgroundColor,
            backgroundImagePath: widget.backgroundImagePath,
            isSaving: widget.isSaving,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
          ...widget.imageLayers.map((layer) => ImageLayerWidget(
              layer: layer,
              onScaleStart: (details) {
                _imageInitialScales[layer.id] = layer.scale;
                _imageInitialPositions[layer.id] = layer.position;
                _imageInitialFocalPoints[layer.id] = details.focalPoint;
                _imageInitialRotations[layer.id] = layer.rotation; // 회전 초기값 저장
              },
              onScaleUpdate: (details) {
                setState(() {
                  if (_imageInitialScales[layer.id] != null) {
                    layer.scale = _imageInitialScales[layer.id]! * details.scale;
                  }

                  if (_imageInitialPositions[layer.id] != null) {
                    final deltaPosition = details.focalPoint - _imageInitialFocalPoints[layer.id]!;
                    layer.position = _imageInitialPositions[layer.id]! + deltaPosition;
                  }

                  if (_imageInitialRotations[layer.id] != null) {
                    layer.rotation = _imageInitialRotations[layer.id]! + details.rotation;
                  }
                });
              },
              onDragStart: widget.onDragStart,
              onDragEnd: widget.onDragEnd,
          )),

          ...widget.textLayers.map((layer) => TextLayerWidget(
            layer: layer,
            onTap: () {
              widget.onTextLayerEdit(layer);
            },
            onScaleStart: (details) {
              _textInitialScales[layer.id] = layer.scale;
              _textInitialPositions[layer.id] = layer.position;
              _textInitialFocalPoints[layer.id] = details.focalPoint;
              _textInitialRotations[layer.id] = layer.rotation; // 회전 초기값 저장
            },
            onScaleUpdate: (details) {
              setState(() {
                if (_textInitialScales[layer.id] != null) {
                  layer.scale = _textInitialScales[layer.id]! * details.scale;
                }

                if (_textInitialPositions[layer.id] != null) {
                  final deltaPosition = details.focalPoint - _textInitialFocalPoints[layer.id]!;
                  layer.position = _textInitialPositions[layer.id]! + deltaPosition;
                }

                if (_textInitialRotations[layer.id] != null) {
                  layer.rotation = _textInitialRotations[layer.id]! + details.rotation;
                }
              });
            },
            onDragStart: widget.onDragStart,
            onDragEnd: widget.onDragEnd,
          ))
        ],
      ),
    );
  }
}
