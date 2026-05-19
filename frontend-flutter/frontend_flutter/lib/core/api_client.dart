import 'package:dio/dio.dart';
import 'config.dart';
import 'token_storage.dart';

class ApiClient {
  final TokenStorage tokenStorage;

  ApiClient(this.tokenStorage) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          final isAuthEndpoint = options.path.startsWith('/foodtrack/auth/');
          if (token != null && token.isNotEmpty && !isAuthEndpoint) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  late final Dio dio;
}