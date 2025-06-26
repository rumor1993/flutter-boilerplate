import 'package:meal/common/const/oauth_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_user_model.freezed.dart';
part 'login_user_model.g.dart';

@freezed
class LoginUserModel with _$LoginUserModel {
  const factory LoginUserModel({
    required String id,
    required String username,
    required String picture,
    required String accessToken,
    required String refreshToken,
    required OauthType socialType
  }) = _LoginUserModel;

  factory LoginUserModel.fromJson(Map<String, Object?> json)
  => _$LoginUserModelFromJson(json);
}
