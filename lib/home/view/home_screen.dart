import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/home/view/image_cutout_processor.dart';
import 'package:flutter_boilerplate/home/view/post_processor.dart';
import 'package:flutter_boilerplate/home/view/selfie_multiclass_segmentation.dart';
import 'package:flutter_boilerplate/home/view/sticker_border.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'animated_face_tracker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final assets = "assets/models/meme.gif";
    final InputImage inputImage;

    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Segment")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
            width: 450,
            height: 379,
            child: AnimatedFaceTracker(),
            ),
          ],
        ),
      ),
    );
  }
}
