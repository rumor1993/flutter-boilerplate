import 'package:photo_app/common/const/data.dart';
import 'package:photo_app/common/dio/dio.dart';
import 'package:photo_app/user/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_me_repository.g.dart';

@riverpod
UserMeRepository userMeRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(dio: dio, baseUrl: 'http://$ip');
}

class UserMeRepository {
  final Dio dio;
  final String baseUrl;

  UserMeRepository({required this.dio, required this.baseUrl});

  Future<UserModel> getMe() async {
    final response = await dio.get(
      '$baseUrl/users/profile',
      options: Options(headers: {'accessToken': 'true'}),
    );
    return UserModel.fromJson(response.data);
  }
}
