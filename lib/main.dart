import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIF Face Replacer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GifFaceReplacer(),
    );
  }
}

class GifFaceReplacer extends StatefulWidget {
  @override
  _GifFaceReplacerState createState() => _GifFaceReplacerState();
}

class _GifFaceReplacerState extends State<GifFaceReplacer> {
  File? userImage;
  bool isProcessing = false;
  String status = "";
  File? resultGif;

  Future<void> pickUserImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        userImage = File(image.path);
      });
    }
  }

  Future<void> processGif() async {
    if (userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('먼저 사진을 선택해주세요'))
      );
      return;
    }

    setState(() {
      isProcessing = true;
      status = "처리 시작...";
    });

    try {
      final String jsonData = await rootBundle.loadString(
          'assets/flutter_face_tracking_20250831_000948.json'
      );
      // JSON 파싱
      Map<String, dynamic> data = json.decode(jsonData);
      List<dynamic> trackingData = data['tracking_data'];

      setState(() {
        status = "원본 GIF 로딩...";
      });

      // 원본 GIF 로드 (assets 폴더에서)
      ByteData gifData = await rootBundle.load('assets/meme4.gif');
      List<int> gifBytes = gifData.buffer.asUint8List();
      img.Animation? originalGif = img.decodeGifAnimation(gifBytes);

      if (originalGif == null) {
        throw Exception('원본 GIF를 디코딩할 수 없습니다');
      }

      setState(() {
        status = "사용자 이미지 로딩...";
      });

      // 사용자 이미지 로드
      Uint8List userImageBytes = await userImage!.readAsBytes();
      img.Image? userPhoto = img.decodeImage(userImageBytes);

      if (userPhoto == null) {
        throw Exception('사용자 이미지를 디코딩할 수 없습니다');
      }

      setState(() {
        status = "얼굴 교체 처리 중...";
      });

      // 프레임별로 얼굴 교체 처리
      List<img.Image> processedFrames = [];

      for (int i = 0; i < trackingData.length && i < originalGif.frames.length; i++) {
        setState(() {
          status = "프레임 ${i + 1}/${trackingData.length} 처리 중...";
        });

        Map<String, dynamic> frameData = trackingData[i];
        Map<String, dynamic> headData = frameData['heads'][0];

        double x = headData['x'].toDouble();
        double y = headData['y'].toDouble();
        double width = headData['width'].toDouble();
        double height = headData['height'].toDouble();

        // 원본 프레임 복사
        img.Image originalFrame = img.Image.from(originalGif.frames[i]);

        // 사용자 사진을 해당 프레임의 얼굴 영역 크기로 리사이즈
        img.Image resizedUserPhoto = img.copyResize(
          userPhoto,
          width: width.round(),
          height: height.round(),
        );

        // 얼굴 모양으로 마스킹 (타원형)
        img.Image maskedUserPhoto = img.Image.from(resizedUserPhoto);
        for (int py = 0; py < maskedUserPhoto.height; py++) {
          for (int px = 0; px < maskedUserPhoto.width; px++) {
            double dx = (px - maskedUserPhoto.width / 2) / (maskedUserPhoto.width / 2);
            double dy = (py - maskedUserPhoto.height / 2) / (maskedUserPhoto.height / 2);
            double distance = dx * dx + dy * dy;

            if (distance > 1.0) {
              maskedUserPhoto.setPixel(px, py, img.Color.fromRgba(0, 0, 0, 0));
            }
          }
        }

        // 원본 프레임의 얼굴 영역을 사용자 얼굴로 교체
        img.copyInto(
          originalFrame,
          maskedUserPhoto,
          dstX: x.round(),
          dstY: y.round(),
          blend: true,
        );

        processedFrames.add(originalFrame);
      }

      setState(() {
        status = "GIF 생성 중...";
      });

      // GIF 애니메이션 생성
      img.Animation animation = img.Animation();
      animation.loopCount = 0; // 무한 반복

      for (img.Image frame in processedFrames) {
        animation.addFrame(frame); // 100ms per frame
      }

      // GIF 인코딩
      List<int> gifBytes1 = img.encodeGifAnimation(animation)!;

      // 파일 저장
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/face_replaced.gif');
      await file.writeAsBytes(gifBytes1);

      setState(() {
        status = "완료!";
        resultGif = file;
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GIF가 성공적으로 생성되었습니다!'))
      );

    } catch (e) {
      setState(() {
        status = "오류 발생: $e";
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GIF Face Replacer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 사용자 이미지 선택
            ElevatedButton.icon(
              onPressed: isProcessing ? null : pickUserImage,
              icon: Icon(Icons.photo),
              label: Text('사진 선택'),
            ),

            SizedBox(height: 16),

            // 선택된 이미지 미리보기
            if (userImage != null) ...[
              Text('선택된 사진:'),
              SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    userImage!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // 처리 버튼
            ElevatedButton.icon(
              onPressed: isProcessing ? null : processGif,
              icon: isProcessing
                  ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Icon(Icons.play_arrow),
              label: Text(isProcessing ? '처리 중...' : 'GIF 생성'),
            ),

            SizedBox(height: 16),

            // 상태 표시
            if (status.isNotEmpty) ...[
              Text('상태: $status'),
              SizedBox(height: 16),
            ],

            // 결과 미리보기
            if (resultGif != null) ...[
              Text('생성된 GIF:'),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      resultGif!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}