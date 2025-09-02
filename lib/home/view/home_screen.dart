import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';

class MenuItem {
  final String title;
  final double padding;
  final String imagePath;

  MenuItem({
    required this.title,
    required this.padding,
    required this.imagePath,
  });
}

class TemplateCategory {
  final String title;
  final List<TemplateItem> templates;

  TemplateCategory({required this.title, required this.templates});
}

class TemplateItem {
  final String name;
  final String imagePath;
  final double padding;

  TemplateItem({required this.name, required this.imagePath, this.padding = 0});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 템플릿 데이터
  final List<TemplateCategory> templateCategories = [
    TemplateCategory(
      title: "기본 캐릭터",
      templates: [
        TemplateItem(
          name: "여자(빨강)",
          imagePath: "assets/images/red.png",
          padding: 20
        ),
        TemplateItem(name: "남자(빨강)", imagePath: "assets/images/boy_red.png"),
        TemplateItem(
          name: "여자(긴팔)",
          imagePath: "assets/images/girl_red.png",
        ),
        TemplateItem(
          name: "남자(긴팔)",
          imagePath: "assets/images/boy_blue.png",
            padding: 10
        ),
        TemplateItem(
          name: "유아(여)",
          imagePath: "assets/images/girl_yellow.png",
            padding: 10
        ),
        TemplateItem(
          name: "유아(남)",
          imagePath: "assets/images/girl_yellow2.png",
            padding: 10
        ),
      ],
    ),
    TemplateCategory(
      title: "스포츠 캐릭터",
      templates: [
        TemplateItem(
          name: "축구(여)",
          imagePath: "assets/images/soccer.png",
        ),
        TemplateItem(name: "아기(남)", imagePath: "assets/images/soccer.png"),
        TemplateItem(
          name: "발레(여)",
          imagePath: "assets/images/image1.png",
        ),
        TemplateItem(
          name: "발레(남)",
          imagePath: "assets/images/image1.png",
        ),
        TemplateItem(
          name: "테니스(여)",
          imagePath: "assets/images/image1.png",
        ),
        TemplateItem(
          name: "테니스(남)",
          imagePath: "assets/images/image1.png",
        ),
      ],
    ),
    TemplateCategory(
      title: "직업 캐릭터",
      templates: [
        TemplateItem(name: "축구선수", imagePath: "assets/images/image1.png"),
        TemplateItem(
          name: "농구선수",
          imagePath: "assets/images/image1.png",
        ),
        TemplateItem(name: "태권도", imagePath: "assets/images/image1.png"),
        TemplateItem(
          name: "리본아기",
          imagePath: "assets/images/image1.png",
        ),
        TemplateItem(name: "졸업생", imagePath: "assets/images/image1.png"),
        TemplateItem(name: "멜빵바지", imagePath: "assets/images/image1.png"),
      ],
    ),
  ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 메뉴 아이템들 (얼굴 누끼, 전신 누끼)
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 14.0,
                childAspectRatio: 0.8, // 타이틀 공간을 위해 세로를 더 길게
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                final List<MenuItem> menuItems = [
                  MenuItem(
                    title: "얼굴 누끼",
                    padding: 40,
                    imagePath: "assets/images/head_only.png",
                  ),
                  MenuItem(
                    title: "전신 누끼",
                    padding: 0,
                    imagePath: "assets/images/image1.png",
                  ),
                ];

                return Column(
                  children: [
                    // 이미지 부분
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: TransparentGridWidget(
                            tileSize: 20.0,
                            lightColor: Colors.white,
                            darkColor: Colors.grey.shade300,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  menuItems[index].padding,
                                ),
                                child: Image.asset(menuItems[index].imagePath),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 타이틀 부분
                    SizedBox(height: 8),
                    Text(
                      menuItems[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 24), // 상단 메뉴와 템플릿 사이 간격

            // 템플릿 카테고리들
            ...templateCategories.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 제목
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // 템플릿 그리드
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 한 줄에 3개씩
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: category.templates.length,
                    itemBuilder: (context, index) {
                      final template = category.templates[index];
                      return GestureDetector(
                        onTap: () {
                          // 템플릿 선택 처리
                          print('선택된 템플릿: ${template.name}');
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: TransparentGridWidget(
                                    tileSize: 15,
                                    lightColor: Colors.white,
                                    darkColor: Colors.grey.shade300,
                                    child: Padding(
                                      padding: EdgeInsets.all(template.padding),
                                      child: Image.asset(
                                        template.imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              template.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24), // 카테고리 간 간격
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}