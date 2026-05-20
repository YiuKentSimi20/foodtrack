import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend_flutter/core/enums/aliment_category.dart';
import 'package:frontend_flutter/features/masuratori/models/nutrition_score.dart';
import '../../../core/api_client.dart';
import '../../auth/models/aliment_dto.dart';
import '../../auth/models/detalii_aliment_response.dart';
import '../../mese/models/inregistrare_aliment_response.dart';

class AlimentRepository {
  final ApiClient apiClient;
  AlimentRepository({required this.apiClient});

  Future<List<AlimentDto>> searchByName(String name) async {
    final resp = await apiClient.dio.get('/foodtrack/aliment/search-by-name', queryParameters: {'name': name});
    final data = resp.data;
    if (data is List) {
      return data.map((e) => AlimentDto.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map && data['data'] is List) {
      // in cazul in care backend returneaza ApiResponse<{data: [...]}>
      return (data['data'] as List).map((e) => AlimentDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Format invalid raspuns search aliment');
  }

  Future<void> addFoodToMeal({
    required int categorieMasaId,
    required DateTime date, // local date (will be formatted)
    required int grams,
    required int idAliment,
  }) async {
    String fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final body = {
      'categorie_masa_id': categorieMasaId,
      'data': fmt(date),
      'grams': grams,
      'id_aliment': idAliment,
    };

    final resp = await apiClient.dio.post('/foodtrack/masa/adauga-inregistrare-aliment', data: body);
    // backend returneaza ApiResponse<InregistrareAlimentResponse> — poți inspecta resp.data
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw Exception('Eroare la adăugare aliment');
    }
  }

  Future<AlimentDto> createAliment({
    required String productName,
    required String? brands,
    required String? code,
    required double energyKcal100g,
    required double fat100g,
    required double saturatedFat100g,
    required double carbohydrates100g,
    required double sugars100g,
    required double fiber100g,
    required double protein100g,
    required double salt100g,
    required String categorie,
  }) async {
    try {
      final resp = await apiClient.dio.post(
        '/foodtrack/aliment',
        data: {
          'product_name': productName,
          'brands': brands,
          'code': code,
          'energy_kcal_100g': energyKcal100g,
          'fat_100g': fat100g,
          'saturated_fat_100g': saturatedFat100g,
          'carbohydrates_100g': carbohydrates100g,
          'sugars_100g': sugars100g,
          'fiber_100g': fiber100g,
          'protein_100g': protein100g,
          'salt_100g': salt100g,
          'categorie': categorie,
        },
      );

      final data = resp.data;
      final Map<String, dynamic> payload;
      if (data is Map && data['data'] is Map) {
        payload = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else {
        throw Exception('Format invalid răspuns creare aliment');
      }

      debugPrint(payload.toString());
      return AlimentDto.fromJson(payload);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la crearea alimentului');
    }
  }

  Future<InregistrareAlimentResponse> modificaGramajInregistrare({
    required int idInregistrare,
    required int grams,
  }) async {
    try {
      final resp = await apiClient.dio.patch(
        '/foodtrack/masa/modifica-gramaj-inregistrare-aliment',
        data: {
          'id_inregistrare': idInregistrare,
          'grams': grams,
        },
      );

      final data = resp.data;
      // backend folosește ApiResponse<...> în multe locuri -> data în resp.data['data']
      final Map<String, dynamic> payload;
      if (data is Map && data['data'] is Map) {
        payload = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else {
        throw Exception('Format invalid răspuns modificaGramaj');
      }

      return InregistrareAlimentResponse.fromJson(payload);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la modificarea gramajului');
    }
  }

  Future<void> stergeInregistrareAliment(int idInregistrare) async {
    try {
      await apiClient.dio.delete('/foodtrack/masa/sterge-inregistrare-aliment/$idInregistrare');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la ștergerea alimentului');
    }
  }

  Future<InregistrareAlimentResponse> adaugaInregistrareManuala({
    required int categorieMasaId,
    required DateTime date,
    required double energyKcal,
    required double fat,
    required double carbohydrates,
    required double fiber,
    required double protein,
  }) async {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    try {
      final resp = await apiClient.dio.post(
        '/foodtrack/masa/inregistrare-manuala',
        data: {
          'categorie_masa_id': categorieMasaId,
          'data': fmt(date),
          'energy_kcal': energyKcal,
          'fat': fat,
          'carbohydrates': carbohydrates,
          'fiber': fiber,
          'protein': protein,
        },
      );

      final data = resp.data;
      final Map<String, dynamic> payload;
      if (data is Map && data['data'] is Map) {
        payload = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else {
        throw Exception('Format invalid răspuns înregistrare manuală');
      }

      return InregistrareAlimentResponse.fromJson(payload);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la adăugarea înregistrării manuale');
    }
  }

  Future<InregistrareAlimentResponse> modificaInregistrareManuala({
    required int id,
    required double calories,
    required double fat,
    required double carbohydrates,
    required double fiber,
    required double protein,
  }) async {
    try {
      final resp = await apiClient.dio.patch(
        '/foodtrack/masa/modifica-inregistrare-manuala',
        data: {
          'id': id,
          'calories': calories,
          'fat': fat,
          'carbohydrates': carbohydrates,
          'fiber': fiber,
          'protein': protein,
        },
      );

      final data = resp.data;
      final Map<String, dynamic> payload;
      if (data is Map && data['data'] is Map) {
        payload = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else {
        throw Exception('Format invalid răspuns modificare înregistrare manuală');
      }

      return InregistrareAlimentResponse.fromJson(payload);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la modificarea înregistrării manuale');
    }
  }

  Future<AlimentDto> updateAliment({
    required int id,
    required String productName,
    String? brands,
    String? code,
    required double energyKcal100g,
    required double protein100g,
    required double carbohydrates100g,
    required double fat100g,
    required double saturatedFat100g,
    required double sugars100g,
    required double fiber100g,
    required double salt100g,
    required String categorie,
  }) async {
    try {
      final resp = await apiClient.dio.put(
        '/foodtrack/aliment',
        queryParameters: {'id': id},
        data: {
          'product_name': productName,
          'brands': brands,
          'code': code,
          'energy_kcal_100g': energyKcal100g,
          'protein_100g': protein100g,
          'carbohydrates_100g': carbohydrates100g,
          'fat_100g': fat100g,
          'saturated_fat_100g': saturatedFat100g,
          'sugars_100g': sugars100g,
          'fiber_100g': fiber100g,
          'salt_100g': salt100g,
          'categorie': categorie,
        },
      );

      final data = resp.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'] is Map ? data['data'] as Map<String, dynamic> : data;
        return AlimentDto.fromJson(payload);
      } else {
        throw Exception('Format invalid răspuns la actualizare aliment');
      }
    } on DioException catch (e) {
      final msg = (e.response?.data is Map) ? e.response?.data['message'] : e.message;
      throw Exception(msg ?? 'Eroare la actualizare aliment');
    }
  }

  Future<List<AlimentDto>> fetchAlimenteUtilizator() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/aliment/alimente-utilizator');
      final data = resp.data;

      if (data is List) {
        return data.map((e) => AlimentDto.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => AlimentDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Format invalid răspuns alimente utilizator');
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Eroare la preluarea alimentelor');
    }
  }

  Future<List<AlimentDto>> fetchAlimenteNevalidate() async {
    try {
      final resp = await apiClient.dio.get('/foodtrack/aliment/alimente-nevalidate');
      final data = resp.data;
      final list = _extractList(data);
      return list.map((e) => AlimentDto.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<AlimentDto> validateAliment(int id) async {
    try {
      final resp = await apiClient.dio.patch(
        '/foodtrack/aliment/validate',
        queryParameters: {'id': id},
      );
      final payload = _extractDataObject(resp.data);
      return AlimentDto.fromJson(payload as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    }
  }

  Future<DetaliiAlimentResponse> getAlimentDetalii(AlimentDto aliment) async {
    final resp = await apiClient.dio.get(
      '/foodtrack/aliment/detalii',
      data: aliment.toJson(),
    );

    if (resp.statusCode != 200) {
      throw Exception('Eroare la incarcarea detaliilor');
    }

    final Map<String, dynamic> payload;
    if (resp.data is Map && resp.data['data'] is Map) {
      payload = Map<String, dynamic>.from(resp.data['data']);
    } else if (resp.data is Map) {
      payload = Map<String, dynamic>.from(resp.data);
    } else {
      throw Exception('Format invalid raspuns detalii aliment');
    }

    return DetaliiAlimentResponse.fromJson(payload);
  }

  Future<AlimentDto> searchByBarcode(String barcode) async {
    try {
      final resp = await apiClient.dio.get(
        '/foodtrack/aliment/search-by-barcode',
        queryParameters: {'barcode': barcode},
      );

      if(resp.statusCode == 404) {
        throw Exception('Alimentul cu codul de bare $barcode nu a fost găsit');
      }

      final data = resp.data;
      final Map<String, dynamic> payload;
      if (data is Map && data['data'] is Map) {
        payload = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else {
        throw Exception('Format invalid răspuns search by barcode');
      }

      return AlimentDto.fromJson(payload);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Eroare la căutarea alimentului');
    }
  }

  Future<AlimentDto> predictFoodFromImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });

      final resp = await apiClient.dio.get(
        '/foodtrack/model/predict',
        data: formData,
      );

      final data = resp.data;
      final Map<String, dynamic> payload;
      if (data is Map && data['data'] is Map) {
        payload = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else {
        throw Exception('Format invalid raspuns predict');
      }

      return AlimentDto.fromJson(payload);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Nu s-a putut recunoaște mâncarea din imagine.');
      }
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Eroare la recunoaștere');
    }
  }

  dynamic _extractDataObject(dynamic data) {
    if (data is Map && data['data'] != null) return data['data'];
    if (data is Map) return data;
    throw Exception('Format invalid răspuns backend');
  }

  List _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    throw Exception('Format invalid răspuns backend');
  }
}