class MasuratoareGrasimeCorporalaDto {
  final double procent;
  final DateTime dataMasuratoare;
  final int? id;

  MasuratoareGrasimeCorporalaDto({
    required this.procent,
    required this.dataMasuratoare,
    this.id,
  });

  factory MasuratoareGrasimeCorporalaDto.fromJson(Map<String, dynamic> json) {
    double? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString().replaceAll(',', '.'));
    }

    return MasuratoareGrasimeCorporalaDto(
      id: json['id'] is num ? (json['id'] as num).toInt() : null,
      procent: parseNum(json['grasime_corporala_procent']) ?? 0.0,
      dataMasuratoare: DateTime.parse(json['data_masuratoare']),
    );
  }
}