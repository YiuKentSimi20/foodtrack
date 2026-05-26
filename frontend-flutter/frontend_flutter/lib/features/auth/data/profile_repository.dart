import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/api_client.dart';
import '../models/date_personale_response.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository({required this.apiClient});

  Future<DatePersonaleResponse> getDatePersonale() async {
    final response = await apiClient.dio.get('/foodtrack/utilizator/date-personale');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return DatePersonaleResponse.fromJson(data);
    }

    throw Exception('Răspuns invalid pentru date personale');
  }

  Future<void> updateDatePersonale({
    required DateTime dataNasterii,
    required String gen,
    required String nivelActivitate,
  }) async {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    try {
      await apiClient.dio.patch(
        '/foodtrack/utilizator/modifica-date-personale',
        data: {
          'data_nasterii': fmt(dataNasterii),
          'gen': gen,
          'nivel_activitate': nivelActivitate,
        },
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la actualizarea datelor personale');
    }
  }
}