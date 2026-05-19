class ObiectivDto {
  final DateTime dataMasuratoare;
  final double obiectivCaloriiZi;
  final double obiectivProteineZi;
  final double obiectivCarbohidratiZi;
  final double obiectivGrasimiZi;

  ObiectivDto({
    required this.dataMasuratoare,
    required this.obiectivCaloriiZi,
    required this.obiectivProteineZi,
    required this.obiectivCarbohidratiZi,
    required this.obiectivGrasimiZi,
  });

  factory ObiectivDto.fromJson(Map<String, dynamic> json) {
    double? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString().replaceAll(',', '.'));
    }

    return ObiectivDto(
      dataMasuratoare: DateTime.parse(json['data']),
      obiectivCaloriiZi: parseNum(json['obiectiv_calorii_zi']) ?? 0.0,
      obiectivProteineZi: parseNum(json['obiectiv_proteine_zi']) ?? 0.0,
      obiectivCarbohidratiZi: parseNum(json['obiectiv_carbohidrati_zi']) ?? 0.0,
      obiectivGrasimiZi: parseNum(json['obiectiv_grasimi_zi']) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': _fmtDate(dataMasuratoare),
      'obiectiv_calorii_zi': obiectivCaloriiZi,
      'obiectiv_proteine_zi': obiectivProteineZi,
      'obiectiv_carbohidrati_zi': obiectivCarbohidratiZi,
      'obiectiv_grasimi_zi': obiectivGrasimiZi,
    };
  }

  String _fmtDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}