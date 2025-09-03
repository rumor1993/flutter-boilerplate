import 'package:flutter/material.dart';

class StickerSelectionWidget extends StatefulWidget {
  const StickerSelectionWidget({super.key});

  @override
  State<StickerSelectionWidget> createState() => _StickerSelectionWidgetState();
}

class _StickerSelectionWidgetState extends State<StickerSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    "assets/images/image_picker_107E0FCD.png",
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
