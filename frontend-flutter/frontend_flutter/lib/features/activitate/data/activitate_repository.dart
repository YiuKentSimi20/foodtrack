import 'package:dio/dio.dart';
import 'package:frontend_flutter/features/activitate/models/inregistrare_activitate_fizica_response.dart';
import '../../../core/api_client.dart';
import '../models/activitate_fizica_dto.dart';

class ActivitateRepository {
  final ApiClient apiClient;

  ActivitateRepository({required this.apiClient});

  // Preia toate activitățile disponibile
  Future<List<ActivitateFizicaDto>> getAllActivities() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/activitate-fizica');

      if (resp.statusCode != 200) {
        throw Exception('Eroare la preluarea activităților');
      }

      final data = resp.data;
      final List<dynamic> list;

      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      } else {
        return [];
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => ActivitateFizicaDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Eroare la preluarea activităților: $e');
    }
  }

  // Adaugă o activitate pentru o zi specifică
  Future<ActivitateFizicaDto> addActivity({
    required int idActivity,
    required DateTime date,
    required double durataMin,
    String? notite,
  }) async {
    try {
      final body = {
        'id': idActivity,
        'data_activitate': _fmtDate(date),
        'durata_min': durataMin,
        'notite': notite,
      };

      final resp = await apiClient.dio.post('/foodtrack/activitate-fizica', data: body);

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('Eroare la adăugare activitate');
      }

      final Map<String, dynamic> payload = resp.data is Map<String, dynamic>
          ? resp.data
          : (resp.data['data'] as Map<String, dynamic>? ?? {});

      return ActivitateFizicaDto.fromJson(payload);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Eroare la adăugare');
    }
  }

  Future<InregistrareActivitateFizicaResponse> updateActivity({
    required int idActivity,
    required double durataMin,
    String? notite,
  }) async {
    try {
      final body = {
        'id': idActivity,
        'durata_min': durataMin,
        'notite': notite,
      };

      final resp = await apiClient.dio.patch('/foodtrack/activitate-fizica', data: body);

      if (resp.statusCode != 200) {
        throw Exception('Eroare la actualizare activitate');
      }

      final payload = resp.data is Map<String, dynamic>
          ? resp.data
          : (resp.data['data'] as Map<String, dynamic>? ?? {});

      return InregistrareActivitateFizicaResponse.fromJson(payload);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Eroare la actualizare');
    }
  }

  Future<void> syncHealthData({
    required List<Map<String, dynamic>> healthData,
  }) async {
    try {


      final resp = await apiClient.dio.post(
          '/foodtrack/activitate-fizica/health-connect',
          data: healthData
      );

      if (resp.statusCode != 200) {
        throw Exception('Eroare la sincronizare date sănătate');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Eroare la sincronizare');
    }
  }

// Și adaugă și metodă de ștergere (bonus)
  Future<void> deleteActivity(int idActivity) async {
    try {
      final resp = await apiClient.dio.delete('/foodtrack/activitate-fizica/$idActivity');

      if (resp.statusCode != 200) {
        throw Exception('Eroare la ștergere activitate');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Eroare la ștergere');
    }
  }

  _fmtDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}