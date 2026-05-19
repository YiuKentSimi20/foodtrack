import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/macro_colors.dart';
import '../../../masuratori/models/obiectiv_response.dart';
import 'macro_pie.dart';

class ObjectiveCard extends StatelessWidget {
  final String obiectivTitle;
  final ObiectivResponse obiectiv;

  const ObjectiveCard({
    super.key,
    required this.obiectivTitle,
    required this.obiectiv,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(obiectivTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Center(
              child: MacroPie(
                proteinPercent: (obiectiv.obiectivProteineProcent * 100).clamp(
                  0.0,
                  100.0,
                ),
                carbsPercent: (obiectiv.obiectivCarbohidratiProcent * 100).clamp(
                  0.0,
                  100.0,
                ),
                fatPercent: (obiectiv.obiectivGrasimiProcent * 100).clamp(0.0, 100.0),
                calories: obiectiv.obiectivCaloriiZi,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _macroLegend(
                  context,
                  MacroColors.proteins,
                  'Proteine - ${obiectiv.obiectivProteineZi.toStringAsFixed(0)} g (${(obiectiv.obiectivProteineProcent * 100).toStringAsFixed(0)}%)',
                  '${obiectiv.proteineKgCorp.toStringAsFixed(2)} g/kg corp',
                ),
                _macroLegend(
                  context,
                  MacroColors.carbs,
                  'Carbohidrați - ${obiectiv.obiectivCarbohidratiZi.toStringAsFixed(0)} g (${(obiectiv.obiectivCarbohidratiProcent * 100).toStringAsFixed(0)}%)',
                  '${obiectiv.carbohidratiKgCorp.toStringAsFixed(2)} g/kg corp',
                ),
                _macroLegend(
                  context,
                  MacroColors.fats,
                  'Grăsimi - ${obiectiv.obiectivGrasimiZi.toStringAsFixed(0)} g (${(obiectiv.obiectivGrasimiProcent * 100).toStringAsFixed(0)}%)',
                  '${obiectiv.grasimiKgCorp.toStringAsFixed(2)} g/kg corp',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _buildImpactText(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroLegend(BuildContext context, Color color, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 8),
            Text(value, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  String _buildImpactText() {
    final kcal = obiectiv.caloriiNeteZi.abs().toStringAsFixed(0);
    final kg = obiectiv.modificareKgSaptamana.abs().toStringAsFixed(2);

    if (obiectiv.caloriiNeteZi > 0) {
      // conform README: plus = deficit
      return 'Dacă urmezi acest obiectiv vei fi într-un deficit caloric de $kcal kcal, '
          'care te va face să scazi în greutate aproximativ $kg kg pe săptămână.';
    }

    if (obiectiv.caloriiNeteZi < 0) {
      // minus = surplus
      return 'Dacă urmezi acest obiectiv vei fi într-un surplus caloric de $kcal kcal, '
          'care te va face să iei în greutate aproximativ $kg kg pe săptămână.';
    }

    return 'Dacă urmezi acest obiectiv vei fi în echilibru caloric (0 kcal), '
        'iar greutatea estimată va rămâne stabilă.';
  }
}
