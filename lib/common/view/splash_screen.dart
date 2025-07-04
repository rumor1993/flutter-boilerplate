import 'package:flutter_boilerplate/common/const/colors.dart';
import 'package:flutter_boilerplate/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static String get routeName => '/splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: MediaQuery.of(context).size.width / 3),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
