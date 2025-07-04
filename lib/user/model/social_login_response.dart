import 'package:flutter_boilerplate/common/const/oauth_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_login_response.freezed.dart';
part 'social_login_response.g.dart';

@freezed
class SocialLoginResponse with _$SocialLoginResponse {
  factory SocialLoginResponse({
    required String socialId,
    required String username,
    required String picture,
    required OauthType socialType,
    required String token,
  }) = _SocialLoginResponse;

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginResponseFromJson(json);
}
