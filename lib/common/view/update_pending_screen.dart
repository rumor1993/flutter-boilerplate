import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatePendingScreen extends StatelessWidget {
  static String get routeName => '/update-pending';

  const UpdatePendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘 컨테이너
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.update,
                size: 60,
                color: Colors.blue.shade400,
              ),
            ),

            SizedBox(height: 40),

            // 메인 텍스트
            Text(
              "업데이트 예정입니다",
              style: GoogleFonts.notoSansKr(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16),

            // 서브 텍스트
            Text(
              "더 나은 서비스로 찾아뵙겠습니다.\n조금만 기다려 주세요.",
              style: GoogleFonts.notoSansKr(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 50),

            // 장식적인 점들
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(Colors.blue.shade300),
                SizedBox(width: 8),
                _buildDot(Colors.blue.shade400),
                SizedBox(width: 8),
                _buildDot(Colors.blue.shade500),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}