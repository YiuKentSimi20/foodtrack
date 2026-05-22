class InregistrareActivitateFizicaResponse {
  final int? id;
  final String? nume;
  final String? dataActivitate; // yyyy-MM-dd
  final double? met;
  final double? durataMin;
  final double? caloriiArse;
  final int? numarPasi;
  final double? utilizatorKg;
  final String? categorie;
  final String? sursaDate;
  final String? notite;

  InregistrareActivitateFizicaResponse({
    this.id,
    this.nume,
    this.dataActivitate,
    this.met,
    this.durataMin,
    this.caloriiArse,
    this.numarPasi,
    this.utilizatorKg,
    this.categorie,
    this.sursaDate,
    this.notite,
  });

  factory InregistrareActivitateFizicaResponse.fromJson(Map<String, dynamic> json) {
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

    return InregistrareActivitateFizicaResponse(
      id: _toInt(json['id']),
      nume: json['nume'] as String?,
      dataActivitate: json['data_activitate'] as String?,
      met: _toDouble(json['met']),
      durataMin: _toDouble(json['durata_min']),
      caloriiArse: _toDouble(json['calorii_arse']),
      numarPasi: _toInt(json['numar_pasi']),
      utilizatorKg: _toDouble(json['utilizator_kg']),
      categorie: json['categorie'] as String?,
      sursaDate: json['sursa_date'] as String?,
      notite: json['notite'] as String?,
    );
  }
}