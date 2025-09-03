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
        title: const Text('템플릿 에디터'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          TemplateCanvasWidget(
              containerKey: _containerKey,
              layers: _layers,
          ),
          StickerSelectionWidget()
        ],
      ),
    );
  }
}
