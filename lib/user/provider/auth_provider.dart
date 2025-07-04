import 'package:photo_app/common/view/root_tab.dart';
import 'package:photo_app/common/view/splash_screen.dart';
import 'package:photo_app/user/model/user_model.dart';
import 'package:photo_app/user/provider/user_me_provider.dart';
import 'package:photo_app/user/view/login_screen.dart';
import 'package:photo_app/user/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<AsyncValue<UserModel?>>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: RootTab.routeName,
      builder: (_, __) => const RootTab(),
      routes: [
        GoRoute(path: 'profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
  ];

  String? redirectLogic(BuildContext context, GoRouterState state) {
    // final AsyncValue<UserModel?> user = ref.read(userMeProvider);
    // final logginIn = state.fullPath == '/login';
    //
    // // Show splash screen while loading user data
    // if (user.isLoading) {
    //   return '/splash';
    // }
    //
    // // Always redirect to home (/) regardless of authentication status
    // if (state.fullPath == '/splash') {
    //   return '/';
    // }
    //
    // // If on login page and user is authenticated, redirect to home
    // if (user.hasValue && user.value != null && logginIn) {
    //   return '/';
    // }

    return null;
  }
}
