import '../../../core/enums/aliment_category.dart';
import '../../masuratori/models/nutrition_score.dart';

class AlimentDto {
  final int id;
  final String? productName;
  final String? brands;
  final String? code;
  final double? energyKcal100g;
  final double? fat100g;
  final double? saturatedFat100g;
  final double? carbohydrates100g;
  final double? sugars100g;
  final double? fiber100g;
  final double? protein100g;
  final double? salt100g;
  final AlimentCategory? categorie;
  final NutritionScore? nutritionScore;

  AlimentDto({
    required this.id,
    this.productName,
    this.brands,
    this.code,
    this.energyKcal100g,
    this.fat100g,
    this.saturatedFat100g,
    this.carbohydrates100g,
    this.sugars100g,
    this.fiber100g,
    this.protein100g,
    this.salt100g,
    this.categorie,
    this.nutritionScore,
  });

  factory AlimentDto.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) =>
        v is num ? v : (v == null ? null : num.tryParse(v.toString()));

    return AlimentDto(
      id: (json['id'] as num).toInt(),
      productName: json['product_name'] as String?,
      brands: json['brands'] as String?,
      code: json['code'] as String?,
      energyKcal100g: parseNum(json['energy_kcal_100g'])?.toDouble() ?? 0.0,
      fat100g: parseNum(json['fat_100g'])?.toDouble() ?? 0.0,
      saturatedFat100g: parseNum(json['saturated_fat_100g'])?.toDouble() ?? 0.0,
      carbohydrates100g: parseNum(json['carbohydrates_100g'])?.toDouble() ?? 0.0,
      sugars100g: parseNum(json['sugars_100g'])?.toDouble() ?? 0.0,
      fiber100g: parseNum(json['fiber_100g'])?.toDouble() ?? 0.0,
      protein100g: parseNum(json['protein_100g'])?.toDouble() ?? 0.0,
      salt100g: parseNum(json['salt_100g'])?.toDouble() ?? 0.0,
      categorie: json['categorie'] != null
          ? AlimentCategory.fromCode(json['categorie'].toString())
          : null,
      nutritionScore: json['nutrition_score'] != null
          ? NutritionScore.fromCode(json['nutrition_score'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'categorie': categorie?.code,
      'nutrition_score': nutritionScore?.toString(),
    };
  }
}