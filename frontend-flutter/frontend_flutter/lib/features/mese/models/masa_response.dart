import 'dart:ffi';

import 'inregistrare_aliment_response.dart';

class MasaResponse {
  final int id;
  final int? categorieMasaId;
  final String data;
  final String? ora;
  final String? notite;
  final double? gramsTotal;
  final double? energyKcalTotal;
  final double? fatTotal;
  final double? saturatedFatTotal;
  final double? carbohydratesTotal;
  final double? sugarsTotal;
  final double? fiberTotal;
  final double? proteinTotal;
  final double? saltTotal;
  final double? proteinPercent;
  final double? carbohydratesPercent;
  final double? fatPercent;
  final List<InregistrareAlimentResponse> alimente;

  MasaResponse({
    required this.id,
    this.categorieMasaId,
    required this.data,
    this.ora,
    this.notite,
    this.gramsTotal,
    this.energyKcalTotal,
    this.fatTotal,
    this.carbohydratesTotal,
    this.fiberTotal,
    this.saturatedFatTotal,
    this.proteinTotal,
    this.saltTotal,
    this.proteinPercent,
    this.carbohydratesPercent,
    this.sugarsTotal,
    this.fatPercent,
    required this.alimente,
  });

  factory MasaResponse.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) =>
        v is num ? v : (v == null ? null : num.tryParse(v.toString()));

    final alimenteJson = (json['alimente'] as List<dynamic>?) ?? [];

    return MasaResponse(
      id: (json['id'] as num).toInt(),
      categorieMasaId: (json['categorie_masa_id'] as num?)?.toInt(),
      data: json['data'] as String? ?? '',
      ora: json['ora'] as String?,
      notite: json['notite'] as String?,
      gramsTotal: parseNum(json['grams_total'])?.toDouble(),
      energyKcalTotal: parseNum(json['energy_kcal_total'])?.toDouble(),
      fatTotal: parseNum(json['fat_total'])?.toDouble(),
      carbohydratesTotal: parseNum(json['carbohydrates_total'])?.toDouble(),
      saturatedFatTotal: parseNum(json['saturated_fat_total'])?.toDouble(),
      fiberTotal: parseNum(json['fiber_total'])?.toDouble(),
      sugarsTotal: parseNum(json['sugars_total'])?.toDouble(),
      proteinTotal: parseNum(json['protein_total'])?.toDouble(),
      saltTotal: parseNum(json['salt_total'])?.toDouble(),
      proteinPercent: parseNum(json['protein_percent'])?.toDouble(),
      carbohydratesPercent: parseNum(json['carbohydrates_percent'])?.toDouble(),
      fatPercent: parseNum(json['fat_percent'])?.toDouble(),
      alimente: alimenteJson
          .map((e) => InregistrareAlimentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}