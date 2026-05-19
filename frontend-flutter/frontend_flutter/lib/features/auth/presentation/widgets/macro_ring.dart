import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/constants/macro_colors.dart';

class MacroRing extends StatelessWidget {
  final double? totalKcal;
  final double? proteinPercent;
  final double? carbsPercent;
  final double? fatPercent;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;

  const MacroRing({
    super.key,
    required this.totalKcal,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  double _safe(double? v) => (v ?? 0).toDouble();
  String _fmt(double? v, {int decimals = 0}) => v == null ? '-' : v.toStringAsFixed(decimals);

  @override
  Widget build(BuildContext context) {
    final p = _safe(proteinPercent) * 100;
    final c = _safe(carbsPercent) * 100;
    final f = _safe(fatPercent) * 100;

    // Dacă backend-ul trimite deja procente în [0..100], le folosim direct.
    // Dacă suma nu e exact 100, chart-ul tot funcționează corect pe proporții.
    final sections = [
      PieChartSectionData(
        value: p <= 0 ? 0.0001 : p,
        color: MacroColors.proteins,
        radius: 10,
        title: '',
      ),
      PieChartSectionData(
        value: c <= 0 ? 0.0001 : c,
        color: MacroColors.carbs,
        radius: 10,
        title: '',
      ),
      PieChartSectionData(
        value: f <= 0 ? 0.0001 : f,
        color: MacroColors.fats,
        radius: 10,
        title: '',
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 130,
          width: 130,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 36,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _fmt(totalKcal, decimals: 0),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Text('kcal'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _macroColumn(
                context: context,
                color: MacroColors.proteins,
                percent: p,
                grams: proteinGrams,
                name: 'Prot.',
              ),
              _macroColumn(
                context: context,
                color: MacroColors.carbs,
                percent: c,
                grams: carbsGrams,
                name: 'Carb.',
              ),
              _macroColumn(
                context: context,
                color: MacroColors.fats,
                percent: f,
                grams: fatGrams,
                name: 'Grăsimi',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _macroColumn({
    required BuildContext context,
    required Color color,
    required double percent,
    required double? grams,
    required String name,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${_fmt(grams, decimals: 1)} g',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}