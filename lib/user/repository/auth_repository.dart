import 'package:photo_app/common/const/data.dart';
import 'package:photo_app/common/const/oauth_type.dart';
import 'package:photo_app/common/dio/dio.dart';
import 'package:photo_app/user/model/login_user_model.dart';
import 'package:photo_app/user/model/social_login_response.dart';
import 'package:photo_app/user/model/token_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: "http://$ip", dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({required this.baseUrl, required this.dio});

  Future<LoginUserModel> login(OauthType type) async {
    final socialLoginResponse = await _loginWithGoogle(type);

    final response = await dio.post(
      '$baseUrl/users/login',
      queryParameters: {"type": "social"},
      data: socialLoginResponse.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    return LoginUserModel.fromJson(response.data);
  }

  Future<TokenResponse> reissue() async {
    final resp = await dio.post(
      '$baseUrl/reissue',
      options: Options(headers: {'refreshToken': 'true'}),
    );

    return TokenResponse.fromJson(resp.data);
  }

  Future<SocialLoginResponse> _loginWithGoogle(OauthType type) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "499518900282-orncbv9lpq4gdbambs5ldbgh4duvgvek.apps.googleusercontent.com",
    );
    var googleSignInAccount = await googleSignIn.signIn();
    var authentication = await googleSignInAccount?.authentication;

    return SocialLoginResponse(
      socialId: googleSignInAccount!.id,
      username: googleSignInAccount.displayName!,
      picture: googleSignInAccount.photoUrl!,
      socialType: type,
      token: authentication!.idToken!,
    );
  }
}
