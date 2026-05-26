class ObiectivCalculatResponse {
  final double protein;
  final double carbohydrates;
  final double fat;

  ObiectivCalculatResponse({
    required this.protein,
    required this.carbohydrates,
    required this.fat,
  });

  factory ObiectivCalculatResponse.fromJson(Map<String, dynamic> json) {
    return ObiectivCalculatResponse(
      protein: (json['protein'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }
}