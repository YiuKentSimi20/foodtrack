class MasuratoareGreutateDto {
  final double greutateKg;
  final DateTime dataMasuratoare;
  final int? id;

  MasuratoareGreutateDto({
    required this.greutateKg,
    required this.dataMasuratoare,
    this.id,
  });

  factory MasuratoareGreutateDto.fromJson(Map<String, dynamic> json) {
    double? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString().replaceAll(',', '.'));
    }

    return MasuratoareGreutateDto(
      id: json['id'] is num ? (json['id'] as num).toInt() : null,
      greutateKg: parseNum(json['greutate_kg']) ?? 0.0,
      dataMasuratoare: DateTime.parse(json['data_masuratoare']),
    );
  }
}