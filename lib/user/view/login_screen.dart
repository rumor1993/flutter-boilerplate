import 'package:photo_app/common/const/oauth_type.dart';
import 'package:photo_app/common/layout/default_layout.dart';
import 'package:photo_app/user/provider/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/generated/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                ref.read(userMeProvider.notifier).login(OauthType.GOOGLE);
              },
              child: Text(AppLocalizations.of(context)!.googleLogin),
            ),
          ),
        ),
      ),
    );
  }
}
