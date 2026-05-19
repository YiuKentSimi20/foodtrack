import 'package:flutter/material.dart';

enum NutritionScore {
  A,
  B,
  C,
  D,
  E,
  UNKNOWN;

  static NutritionScore fromCode(String? raw) {
    switch ((raw ?? '').trim().toUpperCase()) {
      case 'A':
        return NutritionScore.A;
      case 'B':
        return NutritionScore.B;
      case 'C':
        return NutritionScore.C;
      case 'D':
        return NutritionScore.D;
      case 'E':
        return NutritionScore.E;
      default:
        return NutritionScore.UNKNOWN;
    }
  }

  String get label {
    switch (this) {
      case NutritionScore.A:
        return 'A';
      case NutritionScore.B:
        return 'B';
      case NutritionScore.C:
        return 'C';
      case NutritionScore.D:
        return 'D';
      case NutritionScore.E:
        return 'E';
      case NutritionScore.UNKNOWN:
        return '-';
    }
  }

  String get description {
    switch (this) {
      case NutritionScore.A:
        return 'Calitate nutrițională foarte bună';
      case NutritionScore.B:
        return 'Calitate nutrițională bună';
      case NutritionScore.C:
        return 'Calitate nutrițională medie';
      case NutritionScore.D:
        return 'Calitate nutrițională slabă';
      case NutritionScore.E:
        return 'Calitate nutrițională foarte slabă';
      case NutritionScore.UNKNOWN:
        return 'Scor indisponibil';
    }
  }

  Color get color {
    switch (this) {
      case NutritionScore.A:
        return const Color(0xFF1B5E20); // verde inchis
      case NutritionScore.B:
        return const Color(0xFF388E3C); // verde
      case NutritionScore.C:
        return const Color(0xFFF9A825); // galben/amber
      case NutritionScore.D:
        return const Color(0xFFF57C00); // portocaliu
      case NutritionScore.E:
        return const Color(0xFFC62828); // rosu
      case NutritionScore.UNKNOWN:
        return Colors.grey;
    }
  }

  bool get isKnown => this != NutritionScore.UNKNOWN;


}