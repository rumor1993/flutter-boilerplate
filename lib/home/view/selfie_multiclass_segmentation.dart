import 'dart:typed_data';
import 'package:flutter_boilerplate/home/view/multi_segmentation_type.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class SelfieMulticlassSegmentation {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/selfie_multiclass_256x256.tflite');
      print('모델 로드 성공: ${_interpreter!.getInputTensors()}');
    } catch (e) {
      print('모델 로드 실패: $e');
    }
  }

  Future<List<List<List<List<double>>>>> predict(Uint8List imageBytes) async {
    if (_interpreter == null) return [];

    // 1. 이미지 전처리
    final inputImage = img.decodeImage(imageBytes);
    final resized = img.copyResize(inputImage!, width: 256, height: 256);

    // 2. 이미지 정규화 (픽셀을 ai가 알아 들을 수 있게 처리)
    final input = List.generate(1, (_) =>           // [배치크기: 1개 이미지]
    List.generate(256, (_) =>                     // [높이: 256픽셀]
    List.generate(256, (_) =>                   // [너비: 256픽셀]
    List.generate(3, (_) => 0.0))));          // [채널: R,G,B 3개]

    for (int y = 0; y < 256; y++) {
      for (int x = 0; x < 256; x++) {
        final pixel = resized.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }

    // 3. 추론 실행
    final output = List.generate(1, (_) =>
        List.generate(256, (_) =>
            List.generate(256, (_) =>
                List.generate(6, (_) => 0.0))));  // 6채널!

    _interpreter!.run(input, output);
    return output;
  }

  Uint8List maskToImage(List<List<List<List<double>>>> output, {
    List<MultiSegmentationType> targetClasses = const [MultiSegmentationType.hair, MultiSegmentationType.faceSkin, MultiSegmentationType.others],
  }) {
    final maskImage = img.Image(width: 256, height: 256);

    for (int y = 0; y < 256; y++) {
      for (int x = 0; x < 256; x++) {
        // 원하는 클래스들의 확률 합계
        double totalProb = 0.0;
        for (MultiSegmentationType type in targetClasses) {
          totalProb += output[0][y][x][type.classIndex];
        }

        final value = (totalProb * 255).clamp(0, 255).round();
        final pixel = img.ColorRgb8(value, value, value);
        maskImage.setPixel(x, y, pixel);
      }
    }

    return Uint8List.fromList(img.encodePng(maskImage));
  }


}