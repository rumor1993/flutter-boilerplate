import 'package:flutter/material.dart';

class EditorBottomToolbar extends StatefulWidget {
  final void Function() onPhotoTap;
  final void Function() onTextTap;
  final void Function() onBackgroundTap;
  final bool isVisible; // 추가

  const EditorBottomToolbar({super.key, required this.onPhotoTap, required this.onTextTap, required this.onBackgroundTap, required this.isVisible});

  @override
  State<EditorBottomToolbar> createState() => _EditorBottomToolbarState();
}

class _EditorBottomToolbarState extends State<EditorBottomToolbar> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return SizedBox.shrink(); // 또는 Container()
    }

    return Container(
      padding: EdgeInsets.all(20),
      color: Color(0xff1A1A1A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: widget.onPhotoTap,
            child: SizedBox(
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.white,
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
            onTap: widget.onTextTap,
            child: SizedBox(
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.title_outlined,
                      fill: 0.0,
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
            onTap: widget.onBackgroundTap,
            child: SizedBox(
              width: 90, // 동일한 너비
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.texture,
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
    );
  }
}
