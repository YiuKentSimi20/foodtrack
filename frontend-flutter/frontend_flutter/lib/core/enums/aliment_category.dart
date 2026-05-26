import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AlimentCategory {
  altele('ALTELE', 'Altele', 'assets/icons/altele.png'),
  bauturi('BAUTURI', 'Băuturi', 'assets/icons/bauturi.png'),
  branzeturi('BRANZETURI', 'Brânzeturi', 'assets/icons/branzeturi.png'),
  carne('CARNE', 'Carne', 'assets/icons/carne.png'),
  cereale('CEREALE', 'Cereale', 'assets/icons/cereale.png'),
  condimente('CONDIMENTE', 'Condimente', 'assets/icons/condimente.png'),
  dulciuri('DULCIURI', 'Dulciuri', 'assets/icons/dulciuri.png'),
  fastFood('FAST_FOOD', 'Fast Food', 'assets/icons/fast_food.png'),
  fructe('FRUCTE', 'Fructe', 'assets/icons/fructe.png'),
  grasimi('GRASIMI', 'Grăsimi', 'assets/icons/grasimi.png'),
  lactate('LACTATE', 'Lactate', 'assets/icons/lactate.png'),
  legume('LEGUME', 'Legume', 'assets/icons/legume.png'),
  mancareGatita('MANCARE_GATITA', 'Mâncare gătită', 'assets/icons/mancare_gatita.png'),
  mezeluri('MEZELURI', 'Mezeluri', 'assets/icons/mezeluri.png'),
  oua('OUA', 'Ouă', 'assets/icons/oua.png'),
  paine('PAINE', 'Pâine', 'assets/icons/paine.png'),
  peste('PESTE', 'Pește', 'assets/icons/peste.png'),
  seminte('SEMINTE', 'Semințe', 'assets/icons/seminte.png'),
  snackuri('SNACKURI', 'Snack-uri', 'assets/icons/snackuri.png'),
  sosuri('SOSURI', 'Sosuri', 'assets/icons/sosuri.png'),
  suplimente('SUPLIMENTE', 'Suplimente', 'assets/icons/suplimente.png'),;

  final String code;
  final String label;
  final String iconPath;

  const AlimentCategory(this.code, this.label, this.iconPath);

  static AlimentCategory fromCode(String code) {
    try {
      return values.firstWhere((e) => e.code == code);
    } catch (_) {
      return AlimentCategory.altele;
    }
  }

  static List<AlimentCategory> get sortedList => values;
}