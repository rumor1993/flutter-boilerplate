import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/crop/view/body_screen.dart';
import 'package:flutter_boilerplate/crop/view/crop_screen.dart';
import 'package:flutter_boilerplate/home/model/menu_item.dart';

final List<MenuItem> menuItems = [
  MenuItem(
    title: "얼굴 누끼",
    padding: 40,
    imagePath: "assets/images/head_only.png",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder:
                (context) => CropScreen()
        ),
      );
    },
  ),
  MenuItem(
    title: "전신 누끼",
    padding: 0,
    imagePath: "assets/images/image1.png",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder:
                (context) => BodyScreen()
        ),
      );
    },
  ),
];