import 'package:flutter/material.dart';
import 'package:frontend_flutter/presentation/widgets/macro_ring.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/macro_colors.dart';
import '../features/mese/models/mese_pe_zi_response.dart';
import '../core/date_helper.dart';

class NutritionDayDetailPage extends StatelessWidget {
  final MesePeZiResponse day;

  const NutritionDayDetailPage({required this.day, super.key});

  Widget _simpleRecommendationCard({
    required String title,
    required double value,
    required double recommended,
    required String unit,
    required String recommendedLabel,
    Color color = Colors.blue,
    String? extraNote,
  }) {
    final isOver = recommended > 0 ? value > recommended : false;
    if (unit == 'mg') {
      value *= 1000;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} $unit',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recommendedLabel,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  if (extraNote != null) ...[
                    const SizedBox(height: 6),
                    Text(extraNote, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ],
              ),
            ),
            if (isOver && title != 'Fibre' || (title == 'Fibre' && !isOver))
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.warning_amber_rounded, color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }

  Widget _progressRow({
    required String title,
    required double value,
    required double recommended,
    required String unit,
    Color color = Colors.blue,
    String? note,
  }) {
    final pct = recommended > 0 ? (value / recommended).clamp(0.0, 1.0) : 0.0;
    final isOver = value > recommended;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} $unit',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ ${recommended.toStringAsFixed(0)} $unit',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: pct,
              color: color,
              backgroundColor: color.withValues(alpha: 0.16),
              minHeight: 6,
            ),
            if (note != null) ...[
              const SizedBox(height: 8),
              Text(
                note,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
            if (value < recommended)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.warning_amber_rounded, color: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }

  double _safe(double? v) => (v ?? 0).toDouble();
  String _fmt(double? v, {int decimals = 0}) => v == null ? '-' : v.toStringAsFixed(decimals);

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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(day.data);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    final fruits = day.fruitsTotalGrams ?? 0.0;
    final veg = day.vegetablesTotalGrams ?? 0.0;
    final fvRecommended = day.fruitsAndVegetablesRecommendedGrams ?? 400.0;

    final fiber = day.fiberTotal ?? 0.0;
    final fiberRecommended = day.fiberRecommendedGrams ?? 25.0;

    final freeSugars = day.freeSugarsTotal ?? 0.0;
    final freeSugarsRecommended = day.freeSugarsRecommendedGrams ?? 90.0;

    final salt = day.saltTotal ?? 0.0;
    final saltRecommended = day.saltRecommendedGrams ?? 5.0;

    final satFat = day.saturatedFatTotal ?? 0.0;
    final satFatRecommended = day.saturatedFatRecommendedGrams ?? 0.0;

    final burnedCalories = day.caloriiArse ?? 0.0;
    final totalSteps = day.activitatiFizice.fold<int>(
      0,
          (sum, act) => sum + (act.numarPasi ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Analiză: ${DateHelper.formatDateWithDay(parsedDate)}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'Distribuția macronutrienților',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                MacroRing(
                  totalKcal: day.totalCaloriiZi,
                  proteinPercent: day.proteinPercent,
                  carbsPercent: day.carbohydratesPercent,
                  fatPercent: day.fatPercent,
                  proteinGrams: day.totalProteineZi,
                  carbsGrams: day.totalCarbohidratiZi,
                  fatGrams: day.totalGrasimiZi,
                ),
                const SizedBox(height: 4),
                Text('Obiectiv:'),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const SizedBox(width: 30),
                    Text('${day.obiectivCaloriiZi?.toStringAsFixed(0)} kcal'),
                    const SizedBox(width: 40),

                    _macroColumn(
                        context: context,
                        color: MacroColors.proteins,
                        percent: day.obiectivProteineProc! * 100,
                        grams: day.obiectivProteineZi,
                        name: 'Prot.'
                    ),

                    _macroColumn(
                        context: context,
                        color: MacroColors.carbs,
                        percent: day.obiectivCarbohidratiProc! * 100,
                        grams: day.obiectivCarbohidratiZi,
                        name: 'Carb.'
                    ),
                    _macroColumn(
                        context: context,
                        color: MacroColors.fats,
                        percent: day.obiectivGrasimiProc! * 100,
                        grams: day.obiectivGrasimiZi,
                        name: 'Grăsimi'
                    ),
                  ]
                ),
                const SizedBox(height: 20),
              ]
            )
          ),

          const SizedBox(height: 16),

          _progressRow(
            title: 'Fructe & Legume',
            value: fruits + veg,
            recommended: fvRecommended,
            unit: 'g',
            color: Colors.green,
            note: day.fruitsAndVegetablesMessage ?? 'Recomandare: ${fvRecommended.toStringAsFixed(0)} g/zi',
          ),
          const SizedBox(height: 8),

          _simpleRecommendationCard(
            title: 'Fibre',
            value: fiber,
            recommended: fiberRecommended,
            unit: 'g',
            recommendedLabel: day.fiberMessage ?? 'Recomandare: ${fiberRecommended.toStringAsFixed(0)} g/zi',
            color: Colors.teal,
          ),

          _simpleRecommendationCard(
            title: 'Zahăr',
            value: freeSugars,
            recommended: freeSugarsRecommended,
            unit: 'g',
            recommendedLabel: 'OMS recomandă maxim 5-10% din calorii din zaharuri(excluzând fructele și legumele), tu ai consumat un procent de ${(day.freeSugarsPercent!*100).toStringAsFixed(2)}% din caloriile totale',
            color: Colors.orange,
          ),

          _simpleRecommendationCard(
            title: 'Grăsimi saturate',
            value: satFat,
            recommended: satFatRecommended,
            unit: 'g',
            recommendedLabel: 'OMS recomandă ca maxim 10% din calorii să provnă din grăsimi saturate, tu ai consumat un procent de ${(day.saturatedFatPercent!*100).toStringAsFixed(2)}% din caloriile totale',
            color: Colors.purple,
          ),

          _simpleRecommendationCard(
            title: 'Sare',
            value: salt,
            recommended: saltRecommended,
            unit: 'mg',
            recommendedLabel: 'OMS recomandă maxim 5000 mg de sare pe zi, ',
            color: Colors.redAccent,
          ),

          const SizedBox(height: 16),


          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activitate fizică',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Calorii arse',
                    value: '${burnedCalories.round()} kcal',
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.directions_walk_outlined,
                    label: 'Pași',
                    value: '$totalSteps',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Surse:',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(
                  'https://www.who.int/news/item/17-07-2023-who-updates-guidelines-on-fats-and-carbohydrates',
                );
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                } catch (_) {}
              },
              child: Text(
                'Organizația Mondială a Sănătății - updates guidelines on fats and carbohydrates',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),


        ],
      ),
    );
  }
}