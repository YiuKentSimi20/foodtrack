class ActivitateFizicaDto {
  final int? id;
  final String? nume;
  final double? met;
  final String? categorie;

  ActivitateFizicaDto({
    this.id,
    this.nume,
    this.met,
    this.categorie,
  });

  factory ActivitateFizicaDto.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return ActivitateFizicaDto(
      id: _toInt(json['id']),
      nume: json['nume'] as String?,
      met: _toDouble(json['met']),
      categorie: json['categorie'] as String?,
    );
  }
}