import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/api_client.dart';
import '../models/categorie_masa_dto.dart';
import '../models/masa_response.dart';
import '../models/mese_pe_zi_response.dart';

class MasaRepository {
  final ApiClient apiClient;
  MasaRepository({required this.apiClient});

  Future<List<MesePeZiResponse>> fetchRaport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    try {
      final response = await apiClient.dio.get(
        '/foodtrack/masa/raport',
        queryParameters: {
          'startDate': fmt(startDate),
          'endDate': fmt(endDate),
        },
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => MesePeZiResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Format invalid răspuns raport');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la încărcarea raportului');
    }
  }
  Future<List<CategorieMasaDto>> fetchCategoriiMasa() async {
    try {
      final response = await apiClient.dio.get('/foodtrack/masa/categorie-masa');
      final data = response.data;
      if (data is List) {
        final list = data
            .map((e) => CategorieMasaDto.fromJson(e as Map<String, dynamic>))
            .where((c) => c.isActive)
            .toList()
          ..sort((a, b) => a.numarOrdine.compareTo(b.numarOrdine));
        return list;
      } else {
        throw Exception('Format invalid răspuns categorii masă');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la încărcarea categoriilor de masă');
    }
  }

  Future<List<CategorieMasaDto>> fetchAllCategoriiMasa() async {
    try {
      final response = await apiClient.dio.get('/foodtrack/masa/categorie-masa');
      final data = response.data;
      if (data is List) {
        final list = data
            .map((e) => CategorieMasaDto.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.numarOrdine.compareTo(b.numarOrdine));
        return list;
      } else {
        throw Exception('Format invalid răspuns categorii masă');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la încărcarea categoriilor de masă');
    }
  }

  Future<void> updateCategoriiMasa(List<CategorieMasaDto> categories) async {
    try {
      // construim payload: listă de obiecte
      final categorii = categories.map((c) => c.toJson()).toList();
      final payload = {'categorii_mese': categorii};
      await apiClient.dio.put('/foodtrack/masa/categorie-masa', data: payload);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la actualizarea categoriilor de masă');
    }
  }

  Future<MasaResponse> fetchMasaById(int id) async {
    try {
      final response = await apiClient.dio.get('/foodtrack/masa/$id');
      final data = response.data;

      if (data is Map<String, dynamic>) {
        // Dacă backend returnează direct MasaResponse
        if (data.containsKey('id') && data.containsKey('alimente')) {
          return MasaResponse.fromJson(data);
        }

        // Dacă backend returnează ApiResponse<MasaResponse>
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          return MasaResponse.fromJson(inner);
        }
      }

      throw Exception('Format invalid răspuns pentru /masa/{id}');
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message']?.toString())
          : e.message;
      throw Exception(msg ?? 'Eroare la încărcarea detaliilor mesei');
    }
  }

}