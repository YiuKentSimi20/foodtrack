import 'package:flutter/material.dart';

class NutritionTable extends StatelessWidget {
  final String firstRowLabel;
  final double? totalGrams;
  final double? calories;
  final double? protein;
  final double? carbohydrates;
  final double? sugars;
  final double? fat;
  final double? saturatedFat;
  final double? fiber;
  final double? salt;

  const NutritionTable({
    super.key,
    required this.firstRowLabel,
    this.totalGrams,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.sugars,
    this.fat,
    this.saturatedFat,
    this.fiber,
    this.salt,
  });

  Widget _row(String label, String? value, {Color? labelColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _fmt(double? v, {int decimals = 1}) {
    if (v == null) return '-';
    return '${v.toStringAsFixed(decimals)} g';
  }

  String _fmtKcal(double? v) {
    if (v == null) return '-';
    return '${v.toStringAsFixed(0)} kcal';
  }

  String _fmtSalt(double? v) {
    if (v == null) return '-';
    // sarea se trimite în grame, o convertim în mg (× 1000)
    final mg = (v * 1000).toInt();
    return '$mg mg';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cantitate totală
            _row(firstRowLabel, _fmt(totalGrams)),
            const SizedBox(height: 4),
            const Divider(),
            // Calorii
            _row('Calorii', _fmtKcal(calories)),
            const SizedBox(height: 4),
            const Divider(),
            // Macronutrienți
            _row('Grăsimi', _fmt(fat)),
            if (saturatedFat != null) Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _row('   din care saturate', _fmt(saturatedFat)),
            ),
            _row('Carbohidrați', _fmt(carbohydrates)),
            if (sugars != null) Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _row('   din care zaharuri', _fmt(sugars)),
            ),
            _row('Proteine', _fmt(protein)),

            if (fiber != null) _row('Fibre', _fmt(fiber)),
            const SizedBox(height: 4),
            const Divider(),

            // Sare (în mg)
            _row('Sare', _fmtSalt(salt)),
          ],
        ),
      ),
    );
  }
}