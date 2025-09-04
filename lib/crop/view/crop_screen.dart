import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/crop/widget/image_cutout_processor.dart';
import 'package:flutter_boilerplate/crop/widget/post_processor.dart';
import 'package:flutter_boilerplate/crop/widget/selfie_multiclass_segmentation.dart';
import 'package:flutter_boilerplate/crop/widget/sticker_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
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
      final bytes = await image.readAsBytes();
      final output = await _segmentation.predict(bytes);
      final mask = _segmentation.maskToImage(output);

      final processedMask = PostProcessor.processmask(mask);
      final transparentProcessedMask = ImageCutoutProcessor.createCutout(bytes, processedMask);

      setState(() {
        selectedImage = image;
        transparentProcessedMaskImage = StickerBorder.addSimpleBorder(transparentProcessedMask, 0xFFFFFFFF, borderWidth: 15);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Segment")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child:
              selectedImage != null
                  ? Image.file(File(selectedImage!.path))
                  : Text("이미지 선택해주세요."),
            ),

            if (transparentProcessedMaskImage != null) Container(
                color: Colors.black,
                child: Image.memory(transparentProcessedMaskImage!)
            ),

            if (transparentProcessedMaskImage != null) ElevatedButton(
              onPressed: () async {
                final tempDir = await getTemporaryDirectory();
                final file = File('${tempDir.path}/temp_image.png');

                // 2. Uint8List를 파일로 저장
                await file.writeAsBytes(transparentProcessedMaskImage!);

                // 3. 갤러리에 저장
                await GallerySaver.saveImage(file.path);
              },
              child: Text("Download"),
            )
          ],
        ),
      ),
    );
  }
}
