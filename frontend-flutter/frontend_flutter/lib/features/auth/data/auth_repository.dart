import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../models/authentication_request.dart';
import '../models/authentication_response.dart';
import '../models/register_request.dart';

class AuthRepository {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRepository({
    required this.apiClient,
    required this.tokenStorage,
  });

  Future<void> login(AuthenticationRequest request) async {
    try {
      final response = await apiClient.dio.post(
        '/foodtrack/auth/login',
        data: request.toJson(),
      );

      final auth = AuthenticationResponse.fromJson(response.data as Map<String, dynamic>);
      await tokenStorage.saveToken(auth.token);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString() ?? 'Login failed';
        throw Exception(message);
      }
      throw Exception('Nu s-a putut face conexiunea la server.');
    }
  }

  Future<void> logout() => tokenStorage.clearToken();

  Future<void> register(RegisterRequest request) async {
    try {
      final response = await apiClient.dio.post(
        '/foodtrack/auth/register',
        data: request.toJson(),
      );

      final auth = AuthenticationResponse.fromJson(response.data as Map<String, dynamic>);
      await tokenStorage.saveToken(auth.token);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message']?.toString() ?? 'Login failed';
        throw Exception(message);
      }
      throw Exception('Nu s-a putut face conexiunea la server.');
    }
  }

  Future<void> createHeight({
    required double inaltimeCm,
    required String dataMasuratoare, // yyyy-MM-dd
  }) async {
    await apiClient.dio.post(
      '/foodtrack/masuratoare/inaltime',
      data: {
        'inaltime_cm': inaltimeCm,
        'data_masuratoare': dataMasuratoare,
      },
    );
  }

  Future<void> createWeight({
    required double greutateKg,
    required String dataMasuratoare,
  }) async {
    await apiClient.dio.post(
      '/foodtrack/masuratoare/greutate',
      data: {
        'greutate_kg': greutateKg,
        'data_masuratoare': dataMasuratoare,
      },
    );
  }

  Future<void> createBodyFat({
    required double grasimeProcent,
    required String dataMasuratoare,
  }) async {
    await apiClient.dio.post(
      '/foodtrack/masuratoare/grasime-corporala',
      data: {
        'grasime_corporala_procent': grasimeProcent,
        'data_masuratoare': dataMasuratoare,
      },
    );
  }

  Future<void> createGoal({
    required String dataMasuratoare,
    required double calorii,
    required double proteine,
    required double carbohidrati,
    required double grasimi,
  }) async {
    await apiClient.dio.post(
      '/foodtrack/masuratoare/obiective',
      data: {
        'data': dataMasuratoare,
        'obiectiv_calorii_zi': calorii,
        'obiectiv_proteine_zi': proteine,
        'obiectiv_carbohidrati_zi': carbohidrati,
        'obiectiv_grasimi_zi': grasimi,
      },
    );
  }
}