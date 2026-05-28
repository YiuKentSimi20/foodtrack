import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../presentation/login_page.dart';
import 'config.dart';
import 'token_storage.dart';

class ApiClient {
  final TokenStorage tokenStorage;
  late final Dio dio;

  static bool _isRedirectingToLogin = false;

  ApiClient(this.tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

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
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await _handleUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _handleUnauthorized() async {
    if (_isRedirectingToLogin) return;
    _isRedirectingToLogin = true;

    await tokenStorage.clearToken();

    await Future.delayed(const Duration(milliseconds: 300));

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );

    _isRedirectingToLogin = false;
  }
}
