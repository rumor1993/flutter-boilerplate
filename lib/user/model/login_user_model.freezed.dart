// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginUserModel _$LoginUserModelFromJson(Map<String, dynamic> json) {
  return _LoginUserModel.fromJson(json);
}

/// @nodoc
mixin _$LoginUserModel {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get picture => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  OauthType get socialType => throw _privateConstructorUsedError;

  /// Serializes this LoginUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginUserModelCopyWith<LoginUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUserModelCopyWith<$Res> {
  factory $LoginUserModelCopyWith(
    LoginUserModel value,
    $Res Function(LoginUserModel) then,
  ) = _$LoginUserModelCopyWithImpl<$Res, LoginUserModel>;
  @useResult
  $Res call({
    String id,
    String username,
    String picture,
    String accessToken,
    String refreshToken,
    OauthType socialType,
  });
}

/// @nodoc
class _$LoginUserModelCopyWithImpl<$Res, $Val extends LoginUserModel>
    implements $LoginUserModelCopyWith<$Res> {
  _$LoginUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? picture = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? socialType = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
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
            accessToken:
                null == accessToken
                    ? _value.accessToken
                    : accessToken // ignore: cast_nullable_to_non_nullable
                        as String,
            refreshToken:
                null == refreshToken
                    ? _value.refreshToken
                    : refreshToken // ignore: cast_nullable_to_non_nullable
                        as String,
            socialType:
                null == socialType
                    ? _value.socialType
                    : socialType // ignore: cast_nullable_to_non_nullable
                        as OauthType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginUserModelImplCopyWith<$Res>
    implements $LoginUserModelCopyWith<$Res> {
  factory _$$LoginUserModelImplCopyWith(
    _$LoginUserModelImpl value,
    $Res Function(_$LoginUserModelImpl) then,
  ) = __$$LoginUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String username,
    String picture,
    String accessToken,
    String refreshToken,
    OauthType socialType,
  });
}

/// @nodoc
class __$$LoginUserModelImplCopyWithImpl<$Res>
    extends _$LoginUserModelCopyWithImpl<$Res, _$LoginUserModelImpl>
    implements _$$LoginUserModelImplCopyWith<$Res> {
  __$$LoginUserModelImplCopyWithImpl(
    _$LoginUserModelImpl _value,
    $Res Function(_$LoginUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? picture = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? socialType = null,
  }) {
    return _then(
      _$LoginUserModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
        accessToken:
            null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                    as String,
        refreshToken:
            null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                    as String,
        socialType:
            null == socialType
                ? _value.socialType
                : socialType // ignore: cast_nullable_to_non_nullable
                    as OauthType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginUserModelImpl implements _LoginUserModel {
  const _$LoginUserModelImpl({
    required this.id,
    required this.username,
    required this.picture,
    required this.accessToken,
    required this.refreshToken,
    required this.socialType,
  });

  factory _$LoginUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginUserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String picture;
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final OauthType socialType;

  @override
  String toString() {
    return 'LoginUserModel(id: $id, username: $username, picture: $picture, accessToken: $accessToken, refreshToken: $refreshToken, socialType: $socialType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.socialType, socialType) ||
                other.socialType == socialType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    picture,
    accessToken,
    refreshToken,
    socialType,
  );

  /// Create a copy of LoginUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUserModelImplCopyWith<_$LoginUserModelImpl> get copyWith =>
      __$$LoginUserModelImplCopyWithImpl<_$LoginUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginUserModelImplToJson(this);
  }
}

abstract class _LoginUserModel implements LoginUserModel {
  const factory _LoginUserModel({
    required final String id,
    required final String username,
    required final String picture,
    required final String accessToken,
    required final String refreshToken,
    required final OauthType socialType,
  }) = _$LoginUserModelImpl;

  factory _LoginUserModel.fromJson(Map<String, dynamic> json) =
      _$LoginUserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get picture;
  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  OauthType get socialType;

  /// Create a copy of LoginUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginUserModelImplCopyWith<_$LoginUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
