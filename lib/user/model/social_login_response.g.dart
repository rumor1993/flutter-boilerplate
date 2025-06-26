// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialLoginResponseImpl _$$SocialLoginResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SocialLoginResponseImpl(
  socialId: json['socialId'] as String,
  username: json['username'] as String,
  picture: json['picture'] as String,
  socialType: $enumDecode(_$OauthTypeEnumMap, json['socialType']),
  token: json['token'] as String,
);

Map<String, dynamic> _$$SocialLoginResponseImplToJson(
  _$SocialLoginResponseImpl instance,
) => <String, dynamic>{
  'socialId': instance.socialId,
  'username': instance.username,
  'picture': instance.picture,
  'socialType': _$OauthTypeEnumMap[instance.socialType]!,
  'token': instance.token,
};

const _$OauthTypeEnumMap = {
  OauthType.APPLE: 'APPLE',
  OauthType.KAKAO: 'KAKAO',
  OauthType.GOOGLE: 'GOOGLE',
};
