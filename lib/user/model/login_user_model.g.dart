// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginUserModelImpl _$$LoginUserModelImplFromJson(Map<String, dynamic> json) =>
    _$LoginUserModelImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      picture: json['picture'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      socialType: $enumDecode(_$OauthTypeEnumMap, json['socialType']),
    );

Map<String, dynamic> _$$LoginUserModelImplToJson(
  _$LoginUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'picture': instance.picture,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'socialType': _$OauthTypeEnumMap[instance.socialType]!,
};

const _$OauthTypeEnumMap = {
  OauthType.APPLE: 'APPLE',
  OauthType.KAKAO: 'KAKAO',
  OauthType.GOOGLE: 'GOOGLE',
};
