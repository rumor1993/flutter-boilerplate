import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';
import 'package:flutter_boilerplate/editor/widget/layer_widget.dart';

class BasicTemplateEditor extends StatefulWidget {
  final String templateImagePath;

  const BasicTemplateEditor({super.key, required this.templateImagePath});

  @override
  State<BasicTemplateEditor> createState() => _BasicTemplateEditorState();
}

class _BasicTemplateEditorState extends State<BasicTemplateEditor> {
  final GlobalKey _containerKey = GlobalKey();
  
  // 메인 템플릿 이미지도 ImageLayer로 관리
  late ImageLayer _templateLayer;
  
  // 추가된 레이어들
  List<ImageLayer> _layers = [];
  
  // 현재 선택된 레이어
  ImageLayer? _selectedLayer;
  
  // 드래그 관련 변수들
  Offset? _lastFocalPoint;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    // 템플릿 이미지를 ImageLayer로 초기화
    _templateLayer = ImageLayer(
      id: 'template',
      imagePath: widget.templateImagePath,
      position: const Offset(0, 0),
      scale: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('템플릿 에디터'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Stack(
              children: [
                TransparentGridWidget(
                  child: Container(
                    key: _containerKey, // 키 추가
                    width: double.infinity,
                    height: 500,
                  ),
                ),
                // 템플릿 레이어 렌더링
                LayerWidget(
                  layer: _templateLayer,
                  isTemplate: true,
                  onTap: () => _selectLayer(_templateLayer, isTemplate: true),
                  onScaleStart: (details) => _handleScaleStart(_templateLayer, details),
                  onScaleUpdate: (details) => _handleScaleUpdate(_templateLayer, details, isTemplate: true),
                ),
                
                // 추가된 레이어들 렌더링
                ..._layers.map((layer) => LayerWidget(
                  layer: layer,
                  onTap: () => _selectLayer(layer),
                  onDelete: () => _deleteLayer(layer),
                  onScaleStart: (details) => _handleScaleStart(layer, details),
                  onScaleUpdate: (details) => _handleScaleUpdate(layer, details),
                )).toList(),
              ],
            ),
          ),
          Expanded(
            flex: 1, // 스티커 선택 영역 비율
            child: Container(
              color: Colors.black,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 한 줄에 4개
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 8, // 스티커 개수
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // 첫 번째는 "Add a sticker"
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add a \n sticker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 나머지는 실제 스티커들
                    return GestureDetector(
                      onTap: () {
                        _addNewLayer();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset("assets/images/image_picker_107E0FCD.png"),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 새 레이어 추가 메서드
  void _addNewLayer() {
    setState(() {
      final newLayer = ImageLayer(
        id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
        imagePath: "assets/images/image_picker_107E0FCD.png",
        position: Offset(50 + (_layers.length * 20), 50 + (_layers.length * 20)),
        scale: 1.0,
      );
      _layers.add(newLayer);
      _selectedLayer = newLayer;
      print("Added new layer: ${_layers.length} total layers");
    });
  }

  // 레이어 선택 메서드
  void _selectLayer(ImageLayer layer, {bool isTemplate = false}) {
    setState(() {
      _selectedLayer = layer;
      // 모든 레이어의 선택 상태를 해제하고 현재 레이어만 선택
      _layers = _layers.map((l) => l.copyWith(isSelected: l.id == layer.id)).toList();
      if (isTemplate) {
        _templateLayer = _templateLayer.copyWith(isSelected: true);
      } else {
        _templateLayer = _templateLayer.copyWith(isSelected: false);
      }
    });
  }

  // 레이어 삭제 메서드
  void _deleteLayer(ImageLayer layer) {
    setState(() {
      _layers.removeWhere((l) => l.id == layer.id);
      if (_selectedLayer?.id == layer.id) {
        _selectedLayer = null;
      }
      print("Deleted layer: ${_layers.length} remaining layers");
    });
  }

  // 스케일 시작 핸들러
  void _handleScaleStart(ImageLayer layer, ScaleStartDetails details) {
    _baseScale = layer.scale;
    _lastFocalPoint = details.focalPoint;
  }

  // 스케일 업데이트 핸들러
  void _handleScaleUpdate(ImageLayer layer, ScaleUpdateDetails details, {bool isTemplate = false}) {
    setState(() {
      final newScale = (_baseScale * details.scale).clamp(0.1, 5.0);
      
      if (_lastFocalPoint != null) {
        final delta = details.focalPoint - _lastFocalPoint!;
        
        final RenderBox? renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
        
        if (renderBox != null) {
          final containerSize = renderBox.size;
          final imageSize = isTemplate ? 200.0 : 100.0;
          
          double newX = (layer.position.dx + delta.dx).clamp(
            0.0,
            containerSize.width - imageSize,
          );
          double newY = (layer.position.dy + delta.dy).clamp(
            0.0,
            containerSize.height - imageSize,
          );

          final updatedLayer = layer.copyWith(
            position: Offset(newX, newY),
            scale: newScale,
          );

          if (isTemplate) {
            _templateLayer = updatedLayer;
          } else {
            final index = _layers.indexWhere((l) => l.id == layer.id);
            if (index >= 0) {
              _layers[index] = updatedLayer;
            }
          }
        }
        
        _lastFocalPoint = details.focalPoint;
      }
    });
  }
}
