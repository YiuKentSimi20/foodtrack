import 'package:flutter/foundation.dart';

class ObiectivResponse {
  final DateTime data;
  final double obiectivCaloriiZi;
  final double obiectivProteineZi;
  final double obiectivProteineProcent;
  final double obiectivCarbohidratiZi;
  final double obiectivCarbohidratiProcent;
  final double obiectivGrasimiZi;
  final double obiectivGrasimiProcent;
  final double proteineKgCorp;
  final double carbohidratiKgCorp;
  final double grasimiKgCorp;
  final double caloriiNeteZi; // + = deficit, - = surplus
  final double modificareKgSaptamana;

  ObiectivResponse({
    required this.data,
    required this.obiectivCaloriiZi,
    required this.obiectivProteineZi,
    required this.obiectivProteineProcent,
    required this.obiectivCarbohidratiZi,
    required this.obiectivCarbohidratiProcent,
    required this.obiectivGrasimiZi,
    required this.obiectivGrasimiProcent,
    required this.proteineKgCorp,
    required this.carbohidratiKgCorp,
    required this.grasimiKgCorp,
    required this.caloriiNeteZi,
    required this.modificareKgSaptamana,
  });

  factory ObiectivResponse.fromJson(Map<String, dynamic> json) {
    double? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString().replaceAll(',', '.'));
    }

    return ObiectivResponse(
      data: DateTime.parse(json['data'] ?? json['data_masuratoare']),
      obiectivCaloriiZi: parseNum(json['obiectiv_calorii_zi']) ?? 0.0,
      obiectivProteineZi: parseNum(json['obiectiv_proteine_zi']) ?? 0.0,
      obiectivProteineProcent: parseNum(json['obiectiv_proteine_procent']) ?? 0.0,
      obiectivCarbohidratiZi: parseNum(json['obiectiv_carbohidrati_zi']) ?? 0.0,
      obiectivCarbohidratiProcent: parseNum(json['obiectiv_carbohidrati_procent']) ?? 0.0,
      obiectivGrasimiZi: parseNum(json['obiectiv_grasimi_zi']) ?? 0.0,
      obiectivGrasimiProcent: parseNum(json['obiectiv_grasimi_procent']) ?? 0.0,
      proteineKgCorp: parseNum(json['proteine_kg_corp']) ?? 0.0,
      carbohidratiKgCorp: parseNum(json['carbohidrati_kg_corp']) ?? 0.0,
      grasimiKgCorp: parseNum(json['grasimi_kg_corp']) ?? 0.0,
      caloriiNeteZi: parseNum(json['calorii_nete_zi']) ?? 0.0,
      modificareKgSaptamana: parseNum(json['modificare_kg_saptamana']) ?? 0.0,
    );
  }
}