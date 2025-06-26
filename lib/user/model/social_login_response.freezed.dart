// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SocialLoginResponse _$SocialLoginResponseFromJson(Map<String, dynamic> json) {
  return _SocialLoginResponse.fromJson(json);
}

/// @nodoc
mixin _$SocialLoginResponse {
  String get socialId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get picture => throw _privateConstructorUsedError;
  OauthType get socialType => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  /// Serializes this SocialLoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialLoginResponseCopyWith<SocialLoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLoginResponseCopyWith<$Res> {
  factory $SocialLoginResponseCopyWith(
    SocialLoginResponse value,
    $Res Function(SocialLoginResponse) then,
  ) = _$SocialLoginResponseCopyWithImpl<$Res, SocialLoginResponse>;
  @useResult
  $Res call({
    String socialId,
    String username,
    String picture,
    OauthType socialType,
    String token,
  });
}

/// @nodoc
class _$SocialLoginResponseCopyWithImpl<$Res, $Val extends SocialLoginResponse>
    implements $SocialLoginResponseCopyWith<$Res> {
  _$SocialLoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socialId = null,
    Object? username = null,
    Object? picture = null,
    Object? socialType = null,
    Object? token = null,
  }) {
    return _then(
      _value.copyWith(
            socialId:
                null == socialId
                    ? _value.socialId
                    : socialId // ignore: cast_nullable_to_non_nullable
                        as String,
            username:
                null == username
                    ? _value.username
                    : username // ignore: cast_nullable_to_non_nullable
                        as String,
            picture:
                null == picture
                    ? _value.picture
                    : picture // ignore: cast_nullable_to_non_nullable
                        as String,
            socialType:
                null == socialType
                    ? _value.socialType
                    : socialType // ignore: cast_nullable_to_non_nullable
                        as OauthType,
            token:
                null == token
                    ? _value.token
                    : token // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocialLoginResponseImplCopyWith<$Res>
    implements $SocialLoginResponseCopyWith<$Res> {
  factory _$$SocialLoginResponseImplCopyWith(
    _$SocialLoginResponseImpl value,
    $Res Function(_$SocialLoginResponseImpl) then,
  ) = __$$SocialLoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String socialId,
    String username,
    String picture,
    OauthType socialType,
    String token,
  });
}

/// @nodoc
class __$$SocialLoginResponseImplCopyWithImpl<$Res>
    extends _$SocialLoginResponseCopyWithImpl<$Res, _$SocialLoginResponseImpl>
    implements _$$SocialLoginResponseImplCopyWith<$Res> {
  __$$SocialLoginResponseImplCopyWithImpl(
    _$SocialLoginResponseImpl _value,
    $Res Function(_$SocialLoginResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocialLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socialId = null,
    Object? username = null,
    Object? picture = null,
    Object? socialType = null,
    Object? token = null,
  }) {
    return _then(
      _$SocialLoginResponseImpl(
        socialId:
            null == socialId
                ? _value.socialId
                : socialId // ignore: cast_nullable_to_non_nullable
                    as String,
        username:
            null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                    as String,
        picture:
            null == picture
                ? _value.picture
                : picture // ignore: cast_nullable_to_non_nullable
                    as String,
        socialType:
            null == socialType
                ? _value.socialType
                : socialType // ignore: cast_nullable_to_non_nullable
                    as OauthType,
        token:
            null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLoginResponseImpl implements _SocialLoginResponse {
  _$SocialLoginResponseImpl({
    required this.socialId,
    required this.username,
    required this.picture,
    required this.socialType,
    required this.token,
  });

  factory _$SocialLoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLoginResponseImplFromJson(json);

  @override
  final String socialId;
  @override
  final String username;
  @override
  final String picture;
  @override
  final OauthType socialType;
  @override
  final String token;

  @override
  String toString() {
    return 'SocialLoginResponse(socialId: $socialId, username: $username, picture: $picture, socialType: $socialType, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLoginResponseImpl &&
            (identical(other.socialId, socialId) ||
                other.socialId == socialId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.socialType, socialType) ||
                other.socialType == socialType) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, socialId, username, picture, socialType, token);

  /// Create a copy of SocialLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLoginResponseImplCopyWith<_$SocialLoginResponseImpl> get copyWith =>
      __$$SocialLoginResponseImplCopyWithImpl<_$SocialLoginResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLoginResponseImplToJson(this);
  }
}

abstract class _SocialLoginResponse implements SocialLoginResponse {
  factory _SocialLoginResponse({
    required final String socialId,
    required final String username,
    required final String picture,
    required final OauthType socialType,
    required final String token,
  }) = _$SocialLoginResponseImpl;

  factory _SocialLoginResponse.fromJson(Map<String, dynamic> json) =
      _$SocialLoginResponseImpl.fromJson;

  @override
  String get socialId;
  @override
  String get username;
  @override
  String get picture;
  @override
  OauthType get socialType;
  @override
  String get token;

  /// Create a copy of SocialLoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialLoginResponseImplCopyWith<_$SocialLoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
