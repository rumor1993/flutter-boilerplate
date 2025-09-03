import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/home/data/template_data.dart';
import 'package:flutter_boilerplate/home/widget/template_category_section_widget.dart';
import 'package:flutter_boilerplate/home/widget/top_menu_section_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mini Meme',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 메뉴 아이템들 (얼굴 누끼, 전신 누끼)
            TopMenuSectionWidget(),
            // 템플릿 카테고리들 (기본캐릭터, 스포츠)
            ...templateCategories.map((category) {
              return TemplateCategorySectionWidget(category: category);
            }),
          ],
        ),
      ),
    );
  }
}