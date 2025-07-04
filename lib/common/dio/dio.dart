import 'package:photo_app/common/const/data.dart';
import 'package:photo_app/common/config/app_config.dart';
import 'package:photo_app/common/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/secoure_storage/secoure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  // Configure base options
  dio.options = BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
    receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
    sendTimeout: Duration(milliseconds: AppConfig.apiTimeout),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.storage, required this.ref});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Logger.network(options.method, options.uri.toString(), data: options.data);

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      if (token != null) {
        options.headers.addAll({'authorization': 'Bearer $token'});
      }
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      if (token != null) {
        options.headers.addAll({'authorization': 'Bearer $token'});
      }
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    Logger.network(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response: response.data,
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    Logger.error(
      'HTTP Error: ${err.requestOptions.method} ${err.requestOptions.uri}',
      err,
      err.stackTrace,
    );

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          '${AppConfig.apiBaseUrl}/auth/token',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (e) {
        // TODO: authProvider 생성 후 처리 필요
        // ref.read(authProvider.notifier).logout();
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}
