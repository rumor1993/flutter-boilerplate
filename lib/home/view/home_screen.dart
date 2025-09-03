import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/component/transparent_grid_widget.dart';
import 'package:flutter_boilerplate/editor/basic_template_editor.dart';
import 'package:flutter_boilerplate/home/data/template_data.dart';
import 'package:flutter_boilerplate/home/model/menu_item.dart';


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
                        onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BasicTemplateEditor(
                              templateImagePath: template.imagePath,
                            ),
                          ),
                        );
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