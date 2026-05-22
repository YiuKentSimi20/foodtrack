import '../../activitate/models/inregistrare_activitate_fizica_response.dart';
import 'masa_response.dart';

class MesePeZiResponse {
  final String data; // yyyy-MM-dd
  final List<MasaResponse> mese;
  final List<InregistrareActivitateFizicaResponse> activitatiFizice;
  final double? obiectivCaloriiZi;
  final double? obiectivProteineZi;
  final double? obiectivCarbohidratiZi;
  final double? obiectivGrasimiZi;
  final double? totalCaloriiZi;
  final double? totalProteineZi;
  final double? totalCarbohidratiZi;
  final double? totalGrasimiZi;
  final double? caloriiNete;
  final double? caloriiArse;

  MesePeZiResponse({
    required this.data,
    required this.mese,
    required this.activitatiFizice,
    this.obiectivCaloriiZi,
    this.obiectivProteineZi,
    this.obiectivCarbohidratiZi,
    this.obiectivGrasimiZi,
    this.totalCaloriiZi,
    this.totalProteineZi,
    this.totalCarbohidratiZi,
    this.totalGrasimiZi,
    this.caloriiNete,
    this.caloriiArse
  });

  factory MesePeZiResponse.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) =>
        v is num ? v : (v == null ? null : num.tryParse(v.toString()));

    final meseJson = (json['mese'] as List<dynamic>?) ?? [];

    final activitatiJson = (json['activitati_fizice'] as List<dynamic>?) ?? [];

    return MesePeZiResponse(
      data: json['data'] as String? ?? '',
      mese: meseJson
          .map((e) => MasaResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      activitatiFizice: activitatiJson
          .map((e) => InregistrareActivitateFizicaResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      obiectivCaloriiZi: parseNum(json['obiectiv_calorii'])?.toDouble(),
      obiectivProteineZi: parseNum(json['obiectiv_proteine'])?.toDouble(),
      obiectivCarbohidratiZi: parseNum(json['obiectiv_carbohidrati'])?.toDouble(),
      obiectivGrasimiZi: parseNum(json['obiectiv_grasimi'])?.toDouble(),
      totalCaloriiZi: parseNum(json['energy_kcal_total'])?.toDouble(),
      totalProteineZi: parseNum(json['proteine_total'])?.toDouble(),
      totalCarbohidratiZi: parseNum(json['carbohidrati_total'])?.toDouble(),
      totalGrasimiZi: parseNum(json['fat_total'])?.toDouble(),
      caloriiNete: parseNum(json['calorii_nete'])?.toDouble(),
      caloriiArse: parseNum(json['calorii_arse'])?.toDouble(),
    );
  }
}