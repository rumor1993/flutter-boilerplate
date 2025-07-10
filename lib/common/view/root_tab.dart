import 'package:photo_app/common/layout/default_layout.dart';
import 'package:photo_app/home/view/home_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  static String get routeName => '/';

  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: HomeScreen(),
    );
  }
}
