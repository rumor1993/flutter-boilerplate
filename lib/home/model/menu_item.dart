import 'package:flutter/cupertino.dart';

class MenuItem {
  final String title;
  final double padding;
  final String imagePath;
  final void Function(BuildContext context) onTap;

  MenuItem({
    required this.title,
    required this.padding,
    required this.imagePath,
    required this.onTap
  });
}