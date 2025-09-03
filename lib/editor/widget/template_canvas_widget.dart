import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';
import 'package:flutter_boilerplate/editor/widget/layer_widget.dart';

class TemplateCanvasWidget extends StatefulWidget {
  final GlobalKey containerKey;
  final List<ImageLayer> layers;

  const TemplateCanvasWidget({
    super.key,
    required this.containerKey,
    required this.layers,
  });

  @override
  State<TemplateCanvasWidget> createState() => _TemplateCanvasWidgetState();
}

class _TemplateCanvasWidgetState extends State<TemplateCanvasWidget> {
  // 크기 변경을 위한 필드
  final Map<String, double> _initialScales = {};
  // 위치 이동을 위한 필드
  final Map<String, Offset> _initialPositions = {};
  // 제스처 시작할 때의 절대 좌표
  final Map<String, Offset> _initialFocalPoints = {};
  // 회전을 위한 필드
  final Map<String, double> _initialRotations = {}; // 회전 초기값 추가!


  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Stack(
        children: [
          TransparentGridWidget(
            child: SizedBox(
              key: widget.containerKey, // 키 추가
              width: double.infinity,
              height: 500,
            ),
          ),
          ...widget.layers.map((layer) => LayerWidget(
              layer: layer,
              onScaleStart: (details) {
                _initialScales[layer.id] = layer.scale;
                _initialPositions[layer.id] = layer.position;
                _initialFocalPoints[layer.id] = details.focalPoint;
                _initialRotations[layer.id] = layer.rotation; // 회전 초기값 저장
              },
              onScaleUpdate: (details) {
                setState(() {
                  if (_initialScales[layer.id] != null) {
                    layer.scale = _initialScales[layer.id]! * details.scale;
                  }

                  if (_initialPositions[layer.id] != null) {
                    final deltaPosition = details.focalPoint - _initialFocalPoints[layer.id]!;
                    layer.position = _initialPositions[layer.id]! + deltaPosition;
                  }

                  if (_initialRotations[layer.id] != null) {
                    layer.rotation = _initialRotations[layer.id]! + details.rotation;
                  }
                });
              },
          )),
        ],
      ),
    );
  }
}
