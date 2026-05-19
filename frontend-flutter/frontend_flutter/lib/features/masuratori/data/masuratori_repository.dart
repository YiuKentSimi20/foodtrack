import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/features/masuratori/models/masuratoare_grasime_corporala_dto.dart';
import 'package:frontend_flutter/features/masuratori/models/obiectiv_response.dart';
import '../../../core/api_client.dart';
import '../../masuratori/models/masuratoare_greutate_dto.dart';
import '../../masuratori/models/masuratoare_inaltime_dto.dart';
import '../models/obiectiv_dto.dart';

class MasuratoriRepository {
  final ApiClient apiClient;
  MasuratoriRepository({required this.apiClient});

  Future<List<MasuratoareGreutateDto>> fetchGreutate() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/masuratoare/masuratori-greutate');
      final data = resp.data;
      final list = _extractList(data);
      return list.map((e) => MasuratoareGreutateDto.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<List<MasuratoareInaltimeDto>> fetchInaltime() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/masuratoare/masuratori-intaltime');
      final data = resp.data;
      final list = _extractList(data);
      return list.map((e) => MasuratoareInaltimeDto.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<List<MasuratoareGrasimeCorporalaDto>> fetchGrasime() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/masuratoare/masuratori-grasime-corporala');
      final data = resp.data;
      final list = _extractList(data);
      return list.map((e) => MasuratoareGrasimeCorporalaDto.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  // POST create
  Future<MasuratoareGreutateDto> createGreutate({
    required double greutateKg,
    required DateTime dataMasuratoare, // yyyy-MM-dd
  }) async {
    try {
      final body = {
        'greutate_kg': greutateKg,
        'data_masuratoare': _fmtDate(dataMasuratoare),
      };
      final resp = await apiClient.dio.post('/foodtrack/masuratoare/greutate', data: body);
      final payload = _extractDataObject(resp.data);
      debugPrint(payload.toString());
      return MasuratoareGreutateDto.fromJson(payload as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<MasuratoareInaltimeDto> createInaltime({
    required double inaltimeCm,
    required DateTime dataMasuratoare,
  }) async {
    try {
      final body = {
        'inaltime_cm': inaltimeCm,
        'data_masuratoare': _fmtDate(dataMasuratoare),
      };
      final resp = await apiClient.dio.post('/foodtrack/masuratoare/inaltime', data: body);
      final payload = _extractDataObject(resp.data);
      return MasuratoareInaltimeDto.fromJson(payload as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<MasuratoareGrasimeCorporalaDto> createGrasime({
    required double procent,
    required DateTime dataMasuratoare,
  }) async {
    try {
      final body = {
        'grasime_corporala_procent': procent,
        'data_masuratoare': _fmtDate(dataMasuratoare),
      };
      final resp = await apiClient.dio.post('/foodtrack/masuratoare/grasime-corporala', data: body);
      final payload = _extractDataObject(resp.data);
      return MasuratoareGrasimeCorporalaDto.fromJson(payload as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  // Helpers to handle ApiResponse<T> or raw list/object
  List _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    throw Exception('Format invalid răspuns backend');
  }

  dynamic _extractDataObject(dynamic data) {
    if (data is Map && data['data'] != null) return data['data'];
    if (data is Map) return data;
    throw Exception('Format invalid răspuns backend');
  }

  String _fmtDate(DateTime d) {
    return '${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  }

  Future<List<ObiectivResponse>> fetchObiective() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/masuratoare/obiective');
      final data = resp.data;
      final list = _extractList(data);
      return list.map((e) => ObiectivResponse.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<void> createObiectiv({
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

  Future<ObiectivResponse> previewObiectiv(ObiectivDto dto) async {
    try {
      debugPrint('Requesting preview for DTO: ${dto.toJson()}');
      final resp = await apiClient.dio.get(
        '/foodtrack/masuratoare/obiective/preview',
        data: dto.toJson(),
      );

      final payload = resp.data;
      debugPrint('Preview response payload: ${payload.toString()}');
      return ObiectivResponse.fromJson(payload as Map<String, dynamic>);
    } on DioException catch (e) {
      final d = e.response?.data;
      if (d is Map<String, dynamic>) {
        throw Exception(d['message']?.toString() ?? 'Eroare la preview obiectiv');
      }
      throw Exception(e.message ?? 'Eroare la preview obiectiv');
    }
  }
}