import 'package:frontend_flutter/core/enums/nivel_activitate.dart';

class DatePersonaleResponse {
  final String? username;
  final String? email;
  final String? rol;
  final String? dataNasterii;
  final int? varsta;
  final String? gen;
  final NivelActivitate? nivelActivitate;
  final double? bmi;
  final double? bmr;
  final double? tdee;

  DatePersonaleResponse({
    this.username,
    this.email,
    this.rol,
    this.dataNasterii,
    this.varsta,
    this.gen,
    this.nivelActivitate,
    this.bmi,
    this.bmr,
    this.tdee,
  });

  factory DatePersonaleResponse.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) =>
        v is num ? v : (v == null ? null : num.tryParse(v.toString()));

    return DatePersonaleResponse(
      username: json['username'] as String?,
      email: json['email'] as String?,
      rol: json['rol'] as String?,
      dataNasterii: json['data_nasterii'] as String?,
      varsta: (json['varsta'] as num?)?.toInt(),
      gen: json['gen'] as String?,
      nivelActivitate: json['nivel_activitate'] != null ?
          NivelActivitate.fromCode(json['nivel_activitate'].toString())
          : null,
      bmi: parseNum(json['bmi'])?.toDouble(),
      bmr: parseNum(json['bmr'])?.toDouble(),
      tdee: parseNum(json['tdee'])?.toDouble(),
    );
  }
}