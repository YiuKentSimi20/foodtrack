class DetaliiAlimentResponse {
  final double densitateCalorica;
  final double proteinPercent;
  final double carbohydratesPercent;
  final double fatPercent;

  DetaliiAlimentResponse({
    required this.densitateCalorica,
    required this.proteinPercent,
    required this.carbohydratesPercent,
    required this.fatPercent,
  });

  factory DetaliiAlimentResponse.fromJson(Map<String, dynamic> json) {
    return DetaliiAlimentResponse(
      densitateCalorica: (json['densitate_calorica'] as num?)?.toDouble() ?? 0.0,
      proteinPercent: (json['protein_percent'] as num?)?.toDouble() ?? 0.0,
      carbohydratesPercent: (json['carbohydrates_percent'] as num?)?.toDouble() ?? 0.0,
      fatPercent: (json['fat_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'densitate_calorica': densitateCalorica,
    'protein_percent': proteinPercent,
    'carbohydrates_percent': carbohydratesPercent,
    'fat_percent': fatPercent,
  };
}