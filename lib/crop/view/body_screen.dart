import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/crop/widget/image_cutout_processor.dart';
import 'package:flutter_boilerplate/crop/widget/multi_segmentation_type.dart';
import 'package:flutter_boilerplate/crop/widget/post_processor.dart';
import 'package:flutter_boilerplate/crop/widget/selfie_multiclass_segmentation.dart';
import 'package:flutter_boilerplate/crop/widget/sticker_border.dart';
import 'package:flutter_boilerplate/editor/view/basic_template_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  XFile? selectedImage;
  Uint8List? maskImage;
  Uint8List? transparentMaskImage;
  Uint8List? processedMaskImage;
  Uint8List? transparentProcessedMaskImage;
  final SelfieMulticlassSegmentation _segmentation = SelfieMulticlassSegmentation();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _segmentation.loadModel();

    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024 * 1.5,
      maxHeight: 1024 * 1.5,
    );

    if (image != null) {
      // 로딩 다이얼로그 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Processing your image..."),
                ],
              ),
            ),
          );
        },
      );

      final bytes = await image.readAsBytes();
      final output = await _segmentation.predict(bytes);
      final mask = _segmentation.maskToImage(output, targetClasses: MultiSegmentationType.values
          .where((type) => type != MultiSegmentationType.background)
          .toList());

      final processedMask = PostProcessor.processmask(mask);
      final transparentProcessedMask = ImageCutoutProcessor.createCutout(bytes, processedMask);

      final borderedImage = StickerBorder.addSimpleBorder(transparentProcessedMask, 0xFFFFFFFF, borderWidth: 8);
      // 다이얼로그 닫기
      Navigator.of(context).pop();

      // 바로 에디터로 이동
      _navigateToEditor(borderedImage);
    } else {
      // 이미지 선택 취소한 경우 이전 화면으로
      Navigator.of(context).pop();
    }
  }

  Future<void> _navigateToEditor(Uint8List imageBytes) async {
    // 임시 파일로 저장
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(imageBytes);

    // BasicTemplateEditor로 이동
    Navigator.pushReplacement( // pushReplacement로 CropScreen을 대체
      context,
      MaterialPageRoute(
        builder: (context) => BasicTemplateEditor(
          templateImagePath: file.path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("Loading AI model...", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Image picker will open automatically",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
