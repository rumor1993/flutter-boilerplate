import 'package:flutter_boilerplate/common/view/root_tab.dart';
import 'package:flutter_boilerplate/common/view/splash_screen.dart';
import 'package:flutter_boilerplate/user/model/user_model.dart';
import 'package:flutter_boilerplate/user/provider/user_me_provider.dart';
import 'package:flutter_boilerplate/user/view/login_screen.dart';
import 'package:flutter_boilerplate/user/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
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
        GoRoute(
          path: 'profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
  ];

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final AsyncValue<UserModel?> user = ref.read(userMeProvider);
    final logginIn = state.fullPath == '/login';
    
    // Show splash screen while loading user data
    if (user.isLoading) {
      return '/splash';
    }
    
    // If user is not authenticated and not on login page, redirect to login
    if (user.value == null && !logginIn) {
      return '/login';
    }
    
    // If user is authenticated and on login/splash page, redirect to home
    if (user.hasValue && user.value != null && (logginIn || state.fullPath == '/splash')) {
      return '/';
    }
    
    // If there's an error and not on login page, redirect to login
    if (user.hasError && !logginIn) {
      return '/login';
    }

    return null;
  }
}