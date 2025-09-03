import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';
import 'package:flutter_boilerplate/editor/widget/sticker_selection_widget.dart';
import 'package:flutter_boilerplate/editor/widget/template_canvas_widget.dart';

class BasicTemplateEditor extends StatefulWidget {
  final String templateImagePath;

  const BasicTemplateEditor({super.key, required this.templateImagePath});

  @override
  State<BasicTemplateEditor> createState() => _BasicTemplateEditorState();
}

class _BasicTemplateEditorState extends State<BasicTemplateEditor> {
  final GlobalKey _containerKey = GlobalKey();
  List<ImageLayer> _layers = [];

  @override
  void initState() {
    super.initState();
    _layers.add(
      ImageLayer(
        id: 'template',
        imagePath: widget.templateImagePath,
        position: const Offset(0, 0),
        scale: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Canvas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          TemplateCanvasWidget(containerKey: _containerKey, layers: _layers),
          StickerSelectionWidget(
            onLayerAdded: (newLayer) {
              setState(() {
                _layers.add(newLayer); // 여기서 setState
              });
            },
          ),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF57),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            color: Colors.black,
                            size: 38,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Photo", // 단수형으로 변경
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.title,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Text",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  child: SizedBox(
                    width: 90, // 동일한 너비
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.wallpaper,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Background", // 단수형으로 변경
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
