import 'package:flutter_boilerplate/home/model/tempate_item.dart';
import 'package:flutter_boilerplate/home/model/template_category.dart';

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