import 'package:flutter/material.dart';

enum AlimentCategory {
  altele('ALTELE', 'Altele', Icons.category_outlined),
  buturi('BUTURI', 'Băuturi', Icons.local_drink_outlined),
  branzeturi('BRANZETURI', 'Brânzeturi', Icons.egg_outlined),
  carne('CARNE', 'Carne', Icons.set_meal_outlined),
  cereale('CEREALE', 'Cereale', Icons.grain_outlined),
  condimente('CONDIMENTE', 'Condimente', Icons.soup_kitchen_outlined),
  dulciuri('DULCIURI', 'Dulciuri', Icons.cake_outlined),
  fastFood('FAST_FOOD', 'Fast Food', Icons.fastfood_outlined),
  fructe('FRUCTE', 'Fructe', Icons.apple_outlined),
  grasimi('GRASIMI', 'Grăsimi', Icons.oil_barrel_outlined),
  lactate('LACTATE', 'Lactate', Icons.icecream_outlined),
  legume('LEGUME', 'Legume', Icons.eco_outlined),
  mancareGatita('MANCARE_GATITA', 'Mâncare gătită', Icons.soup_kitchen_outlined),
  mezeluri('MEZELURI', 'Mezeluri', Icons.lunch_dining_outlined),
  oua('OUA', 'Ouă', Icons.egg_outlined),
  paine('PAINE', 'Pâine', Icons.bakery_dining_outlined),
  personal('PERSONAL', 'Personal', Icons.person_outline),
  peste('PESTE', 'Pește', Icons.set_meal_outlined),
  seminte('SEMINTE', 'Semințe', Icons.spa_outlined),
  snackuri('SNACKURI', 'Snack-uri', Icons.cookie_outlined),
  sosuri('SOSURI', 'Sosuri', Icons.soup_kitchen_outlined),
  suplimente('SUPLIMENTE', 'Suplimente', Icons.medication_outlined);

  final String code;
  final String label;
  final IconData icon;

  const AlimentCategory(this.code, this.label, this.icon);

  static AlimentCategory fromCode(String code) {
    try {
      return values.firstWhere((e) => e.code == code);
    } catch (_) {
      return AlimentCategory.altele;
    }
  }

  static List<AlimentCategory> get sortedList => values;
}