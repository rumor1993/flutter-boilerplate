import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/editor/model/image_layer.dart';
import 'package:flutter_boilerplate/editor/model/text_layer.dart';
import 'package:flutter_boilerplate/editor/widget/editor_bottom_toolbar.dart';
import 'package:flutter_boilerplate/editor/widget/template_canvas_widget.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:text_editor/text_editor.dart';

class BasicTemplateEditor extends StatefulWidget {
  final String templateImagePath;

  const BasicTemplateEditor({super.key, required this.templateImagePath});

  @override
  State<BasicTemplateEditor> createState() => _BasicTemplateEditorState();
}

class _BasicTemplateEditorState extends State<BasicTemplateEditor> {
  final GlobalKey _containerKey = GlobalKey();
  final List<ImageLayer> _imageLayers = [];
  final List<TextLayer> _textLayers = [];
  Color? _backgroundColor;
  String? _backgroundImagePath;
  bool _isSaving = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _imageLayers.add(
      ImageLayer(
        id: 'template-image',
        imagePath: widget.templateImagePath,
        position: const Offset(0, 0),
        scale: 1.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xff1A1A1A),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveImage,
            child: Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 6,
            child: TemplateCanvasWidget(
              containerKey: _containerKey,
              imageLayers: _imageLayers,
              textLayers: _textLayers,
              backgroundColor: _backgroundColor,
              backgroundImagePath: _backgroundImagePath,
              onTextLayerEdit: _showTextEditor,
              isSaving: _isSaving
            ),
          ),

          Flexible(
            flex: 3,
            child: Center(
              child: EditorBottomToolbar(
                isVisible: _isVisible,
                onPhotoTap: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (image != null) {
                    setState(() {
                      _imageLayers.add(
                        ImageLayer(
                          id: "image-${DateTime.now().millisecondsSinceEpoch}",
                          imagePath: image.path,
                        ),
                      );
                    });
                  }
                },
                onTextTap: () {
                  setState(() {
                    final newLayer = TextLayer(
                      id: "text-${DateTime.now().millisecondsSinceEpoch}", // 고유 ID
                      text: "text",
                    );

                    _textLayers.add(newLayer);
                    _showTextEditor(newLayer);
                  });
                },
                onBackgroundTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _buildDiscoverDrawer(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 여기에 추가!
  void _showTextEditor(TextLayer layer) {
    // 편집 시작하면 기본 위치에 있던걸 잠시 숨김
    setState(() {
      _isVisible = false;
      final index = _textLayers.indexWhere((l) => l.id == layer.id);
      if (index >= 0) {
        _textLayers[index] = layer.hide();
      }
    });

    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return Container(
          color: Colors.black.withOpacity(0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: TextEditor(
                fonts: ['1', '2'],
                text: layer.text,
                textStyle: layer.textStyle,
                textAlingment: layer.textAlign,
                minFontSize: 10,
                onEditCompleted: (style, align, text) {
                  setState(() {
                    final updatedLayer = layer
                        .updateText(text)
                        .changeTextStyle(style)
                        .changeTextAlign(align);

                    final index = _textLayers.indexWhere(
                      (l) => l.id == layer.id,
                    );
                    if (index >= 0) {
                      _textLayers[index] = updatedLayer;
                    }

                    _isVisible = true;
                  });

                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverDrawer() {
    return DraggableScrollableSheet(
      maxChildSize: 0.95,
      minChildSize: 0.25,
      initialChildSize: 0.6,
      builder: (context, scrollController) {
        final themeColors = [
          {'name': 'White', 'color': Color(0xFFFFFFFF)},
          {'name': 'Off-White', 'color': Color(0xFFF5F5F5)},
          {'name': 'Soft Pink', 'color': Color(0xFFF8BBD0)},
          {'name': 'Pale Blue', 'color': Color(0xFFE1F5FE)},
          {'name': 'Mint', 'color': Color(0xFFB9F6CA)},
          {'name': 'Warm Yellow', 'color': Color(0xFFFFF8E1)},
          {'name': 'Soft Lavender', 'color': Color(0xFFE1BEE7)},
          {'name': 'Coral', 'color': Color(0xFFFFA07A)},
          {'name': 'Beige', 'color': Color(0xFFFFF8DC)},
        ];

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // 핸들바 + 제목이 포함된 고정 헤더
              SliverAppBar(
                backgroundColor: Color(0xFF1C1C1E),
                elevation: 0,
                pinned: true,
                toolbarHeight: 90,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // 핸들바
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 16),
                      // 제목
                      Text(
                        'Choose Background',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 컬러 그리드
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final theme = themeColors[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _backgroundColor = theme['color'] as Color;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // 그라데이션 오버레이
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // 테마 이름
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Text(
                                theme['name'] as String,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // 상태 인디케이터
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: themeColors.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveImage() async {
    try {
      setState(() => _isSaving = true);

      // 다음 프레임이 렌더링된 후 실행
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // 1. 권한 확인
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps == PermissionState.authorized || ps == PermissionState.limited) {

          // 2. 위젯을 이미지로 캡처
          RenderRepaintBoundary boundary = _containerKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;

          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );

          // 3. 임시 파일로 저장
          final directory = await getTemporaryDirectory();
          final file = File('${directory.path}/meme_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(byteData!.buffer.asUint8List());

          // 4. 갤러리에 저장
          await GallerySaver.saveImage(file.path);

          // 5. 성공 메시지
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('갤러리에 저장되었습니다!')),
          );

          setState(() => _isSaving = false);
          Navigator.pop(context);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }
}
