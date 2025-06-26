import 'package:meal/common/const/data.dart';
import 'package:meal/common/const/oauth_type.dart';
import 'package:meal/common/secoure_storage/secoure_storage.dart';
import 'package:meal/user/model/user_model.dart';
import 'package:meal/user/repository/auth_repository.dart';
import 'package:meal/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, AsyncValue<UserModel?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: userMeRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(AsyncValue.loading()) {
    // 초기 상태 가져오기
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // 토큰이 없으면 상태를 null로 설정
    if (refreshToken == null || accessToken == null) {
      state = AsyncValue.data(null);
      return;
    }

    try {
      final resp = await repository.getMe();
      state = AsyncValue.data(resp);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // 로그인 처리
  Future<void> login(OauthType oauthType) async {
    try {
      final resp = await authRepository.login(oauthType);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();
      state = AsyncValue.data(userResp);

    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);

    state = AsyncValue.data(null);  // 로그아웃 후 상태를 null로 설정
  }
}
