// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      picture: json['picture'] as String?,
      cover: json['cover'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'status': instance.status,
      'description': instance.description,
      'picture': instance.picture,
      'cover': instance.cover,
      'role': instance.role,
    };
