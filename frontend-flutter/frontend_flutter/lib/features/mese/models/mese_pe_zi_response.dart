import '../../activitate/models/inregistrare_activitate_fizica_response.dart';
import 'masa_response.dart';

class MesePeZiResponse {
  final String data; // yyyy-MM-dd
  final List<MasaResponse> mese;
  final List<InregistrareActivitateFizicaResponse> activitatiFizice;

  // Calorii și macronutrienți (total și obiective)
  final double? obiectivCaloriiZi;
  final double? obiectivProteineZi;
  final double? obiectivCarbohidratiZi;
  final double? obiectivGrasimiZi;
  final double? totalCaloriiZi;
  final double? totalProteineZi;
  final double? totalCarbohidratiZi;
  final double? totalGrasimiZi;
  final double? proteinPercent;
  final double? carbohydratesPercent;
  final double? fatPercent;

  // Procente macronutrienți obiectiv
  final double? obiectivProteineProc;
  final double? obiectivCarbohidratiProc;
  final double? obiectivGrasimiProc;

  // Calorii nete și arse
  final double? caloriiNete;
  final double? caloriiArse;

  // Grasimi și zaharuri (proprietăți suplimentare)
  final double? fatTotal;
  final double? saturatedFatTotal;
  final double? saturatedFatRecommendedGrams;
  final double? saturatedFatPercent;
  final double? sugarsTotal;
  final double? freeSugarsTotal;
  final double? freeSugarsPercent;
  final double? freeSugarsRecommendedGrams;

  // Fibre
  final double? fiberTotal;
  final double? fiberRecommendedGrams;
  final String? fiberMessage;

  // Sare
  final double? saltTotal;
  final double? saltRecommendedGrams;

  // Fructe și legume
  final double? fruitsTotalGrams;
  final double? vegetablesTotalGrams;
  final double? fruitsAndVegetablesRecommendedGrams;
  final String? fruitsAndVegetablesMessage;

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
    this.proteinPercent,
    this.carbohydratesPercent,
    this.obiectivProteineProc,
    this.obiectivCarbohidratiProc,
    this.obiectivGrasimiProc,
    this.caloriiNete,
    this.caloriiArse,
    this.fatTotal,
    this.fatPercent,
    this.saturatedFatTotal,
    this.saturatedFatRecommendedGrams,
    this.saturatedFatPercent,
    this.sugarsTotal,
    this.freeSugarsTotal,
    this.freeSugarsPercent,
    this.freeSugarsRecommendedGrams,
    this.fiberTotal,
    this.fiberRecommendedGrams,
    this.fiberMessage,
    this.saltTotal,
    this.saltRecommendedGrams,
    this.fruitsTotalGrams,
    this.vegetablesTotalGrams,
    this.fruitsAndVegetablesRecommendedGrams,
    this.fruitsAndVegetablesMessage,
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
          .map((e) => InregistrareActivitateFizicaResponse.fromJson(
          e as Map<String, dynamic>))
          .toList(),
      // Calorii și macronutrienți
      obiectivCaloriiZi: parseNum(json['obiectiv_calorii'])?.toDouble(),
      obiectivProteineZi: parseNum(json['obiectiv_proteine'])?.toDouble(),
      obiectivCarbohidratiZi:
      parseNum(json['obiectiv_carbohidrati'])?.toDouble(),
      obiectivGrasimiZi: parseNum(json['obiectiv_grasimi'])?.toDouble(),
      totalCaloriiZi: parseNum(json['energy_kcal_total'])?.toDouble(),
      totalProteineZi: parseNum(json['proteine_total'])?.toDouble(),
      totalCarbohidratiZi: parseNum(json['carbohidrati_total'])?.toDouble(),
      totalGrasimiZi: parseNum(json['fat_total'])?.toDouble(),
      proteinPercent: parseNum(json['protein_percent'])?.toDouble(),
      carbohydratesPercent: parseNum(json['carbohydrates_percent'])?.toDouble(),
      fatPercent: parseNum(json['fat_percent'])?.toDouble(),

      // Procente obiective
      obiectivProteineProc:
      parseNum(json['obiectiv_proteine_procent'])?.toDouble(),
      obiectivCarbohidratiProc:
      parseNum(json['obiectiv_carbohidrati_procent'])?.toDouble(),
      obiectivGrasimiProc:
      parseNum(json['obiectiv_grasimi_procent'])?.toDouble(),
      // Net calories
      caloriiNete: parseNum(json['calorii_nete'])?.toDouble(),
      caloriiArse: parseNum(json['calorii_arse'])?.toDouble(),
      // Grasimi
      fatTotal: parseNum(json['fat_total'])?.toDouble(),
      saturatedFatTotal:
    parseNum(json['saturated_fat_total'])?.toDouble(),
      saturatedFatRecommendedGrams:
    parseNum(json['saturated_fat_recommended_grams'])?.toDouble(),
      saturatedFatPercent:
      parseNum(json['saturated_fat_percent'])?.toDouble(),
      // Zaharuri
      sugarsTotal: parseNum(json['sugars_total'])?.toDouble(),
      freeSugarsTotal: parseNum(json['free_sugars_total'])?.toDouble(),
      freeSugarsPercent: parseNum(json['free_sugars_percent'])?.toDouble(),
      freeSugarsRecommendedGrams:
      parseNum(json['free_sugars_recommended_grams'])?.toDouble(),
      // Fibre
      fiberTotal: parseNum(json['fiber_total'])?.toDouble(),
      fiberRecommendedGrams:
      parseNum(json['fiber_recommended_grams'])?.toDouble(),
      fiberMessage: json['fiber_message'] as String?,
      // Sare
      saltTotal: parseNum(json['salt_total'])?.toDouble(),
      saltRecommendedGrams:
      parseNum(json['salt_recommended_grams'])?.toDouble(),
      // Fructe și legume
      fruitsTotalGrams: parseNum(json['fruits_total_grams'])?.toDouble(),
      vegetablesTotalGrams:
      parseNum(json['vegetables_total_grams'])?.toDouble(),
      fruitsAndVegetablesRecommendedGrams:
      parseNum(json['fruits_and_vegetables_recommended_grams'])?.toDouble(),
      fruitsAndVegetablesMessage:
      json['fruits_and_vegetables_message'] as String?,
    );
  }
}