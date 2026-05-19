import 'package:frontend_flutter/core/enums/aliment_category.dart';

import '../../masuratori/models/nutrition_score.dart';

class InregistrareAlimentResponse {
  final int id;
  final String? productName;
  final String? brands;
  final String? code;
  final double? grams;
  final double? energyKcal100g;
  final double? fat100g;
  final double? carbohydrates100g;
  final double? protein100g;
  final double? energyKcalTotal;
  final double? fatTotal;
  final double? carbohydratesTotal;
  final double? proteinTotal;
  final double? fiber100g;
  final double? fibarTotal;
  final double? sugars100g;
  final double? sugarsTotal;
  final double? saturatedFat100g;
  final double? saturatedFatTotal;
  final double? salt100g;
  final double? saltTotal;
  final AlimentCategory? categorie;
  final NutritionScore? nutritionScore;
  final String? tipInregistrare;

  InregistrareAlimentResponse({
    required this.id,
    this.productName,
    this.brands,
    this.code,
    this.grams,
    this.energyKcal100g,
    this.fat100g,
    this.carbohydrates100g,
    this.protein100g,
    this.energyKcalTotal,
    this.fatTotal,
    this.carbohydratesTotal,
    this.proteinTotal,
    this.fiber100g,
    this.fibarTotal,
    this.sugars100g,
    this.sugarsTotal,
    this.saturatedFat100g,
    this.saturatedFatTotal,
    this.salt100g,
    this.saltTotal,
    this.categorie,
    this.nutritionScore,
    this.tipInregistrare,
  });

  factory InregistrareAlimentResponse.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) =>
        v is num ? v : (v == null ? null : num.tryParse(v.toString()));

    return InregistrareAlimentResponse(
      id: (json['id'] as num).toInt(),
      productName: json['product_name'] as String?,
      brands: json['brands'] as String?,
      code: json['code'] as String?,
      grams: parseNum(json['grams'])?.toDouble(),
      energyKcal100g: parseNum(json['energy_kcal_100g'])?.toDouble(),
      fat100g: parseNum(json['fat_100g'])?.toDouble(),
      carbohydrates100g: parseNum(json['carbohydrates_100g'])?.toDouble(),
      protein100g: parseNum(json['protein_100g'])?.toDouble(),
      energyKcalTotal: parseNum(json['energy_kcal_total'])?.toDouble(),
      fatTotal: parseNum(json['fat_total'])?.toDouble(),
      carbohydratesTotal: parseNum(json['carbohydrates_total'])?.toDouble(),
      proteinTotal: parseNum(json['protein_total'])?.toDouble(),
      fiber100g: parseNum(json['fiber_100g'])?.toDouble(),
      fibarTotal: parseNum(json['fibar_total'])?.toDouble(),
      sugars100g: parseNum(json['sugars_100g'])?.toDouble (),
      sugarsTotal: parseNum(json['sugars_total'])?.toDouble(),
      saturatedFat100g: parseNum(json['saturated_fat_100g'])?.toDouble(),
      saturatedFatTotal: parseNum(json['saturated_fat_total'])?.toDouble(),
      salt100g: parseNum(json['salt_100g'])?.toDouble(),
      saltTotal: parseNum(json['salt_total'])?.toDouble(),
      categorie: json['categorie'] != null
          ? AlimentCategory.fromCode(json['categorie'].toString())
          : null,
      nutritionScore: json['nutrition_score'] != null
          ? NutritionScore.fromCode(json['nutrition_score'].toString())
          : null,
      tipInregistrare: json['tip_inregistrare'] as String?,
    );
  }
}