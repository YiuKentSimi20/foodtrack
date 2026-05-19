class MasuratoareInaltimeDto {
  final double inaltimeCm;
  final DateTime dataMasuratoare;
  final int? id;

  MasuratoareInaltimeDto({
    required this.inaltimeCm,
    required this.dataMasuratoare,
    this.id,
  });

  factory MasuratoareInaltimeDto.fromJson(Map<String, dynamic> json) {
    double? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString().replaceAll(',', '.'));
    }

    return MasuratoareInaltimeDto(
      id: json['id'] is num ? (json['id'] as num).toInt() : null,
      inaltimeCm: parseNum(json['inaltime_cm']) ?? 0.0,
      dataMasuratoare: DateTime.parse(json['data_masuratoare']),
    );
  }
}