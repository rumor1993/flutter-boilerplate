import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomImageViewer extends StatelessWidget {
  const CustomImageViewer({
    super.key,
    required this.imagePath,
    this.title,
    this.heroTag,
  });

  final String imagePath;
  final String? title;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PhotoView
          heroTag != null
              ? Hero(tag: heroTag!, child: _buildPhotoView())
              : _buildPhotoView(),

          // 닫기 버튼
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: _buildCloseButton(context),
          ),

          // 제목 (있는 경우)
          if (title != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 80, // 닫기 버튼 공간 확보
              child: _buildTitle(),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoView() {
    return PhotoView(
      imageProvider: AssetImage(imagePath),
      backgroundDecoration: BoxDecoration(color: Colors.black),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 3.0,
      enableRotation: false, // 회전 비활성화
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: '닫기',
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Static 메서드로 쉽게 호출할 수 있도록
  static void show(
    BuildContext context, {
    required String imagePath,
    String? title,
    String? heroTag,
  }) {
    if (heroTag != null) {
      // Hero 애니메이션 사용 (가장 자연스러움)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CustomImageViewer(
                imagePath: imagePath,
                title: title,
                heroTag: heroTag,
              ),
        ),
      );
    } else {
      // 아래에서 위로 슬라이드 (일반적인 모달 스타일)
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => CustomImageViewer(
                imagePath: imagePath,
                title: title,
                heroTag: heroTag,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 300),
        ),
      );
    }
  }
}
