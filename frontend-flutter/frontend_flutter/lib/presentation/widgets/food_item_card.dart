import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/constants/macro_colors.dart';
import 'package:frontend_flutter/core/enums/aliment_category.dart';
import 'package:frontend_flutter/presentation/widgets/nutrition_table.dart';
import 'package:frontend_flutter/features/masuratori/models/nutrition_score.dart';
import '../../features/mese/models/inregistrare_aliment_response.dart';

class FoodItemCard extends StatelessWidget {
  final int? id;
  final String? productName;
  final String? brands;
  final double? grams;
  final double? calories;
  final double? protein;
  final double? carbohydrates;
  final double? fat;
  final AlimentCategory? category;
  final NutritionScore? nutritionScore;
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    this.id,
    this.productName,
    this.brands,
    this.grams,
    this.calories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.category,
    this.nutritionScore,
    this.onTap,
  });

  String _fmtInt(double? v) => v == null ? '-' : v.round().toString();

  Widget _smallStat(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _macroText(
    BuildContext context, {
    required String label,
    required double? value,
    required Color color,
  }) {
    return Text(
      '$label ${_fmtInt(value)}g',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 14);

    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 12);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.12),
                child: Image(
                  image: AssetImage(
                    category?.iconPath ?? AlimentCategory.altele.iconPath,
                  ),
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName ?? 'Aliment #${id}',
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (brands != null && brands!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        brands!,
                        style: subtitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),

                    // Rând 1: cantitate + calorii, fără chenar
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        if ((productName ?? '') != 'Intrare manuala')
                          _smallStat(
                            context,
                            icon: Icons.scale,
                            text: '${_fmtInt(grams)} g',
                            color: Colors.blue,
                          ),
                        _smallStat(
                          context,
                          icon: Icons.local_fire_department,
                          text: '${_fmtInt(calories! * grams! / 100)} kcal',
                          color: Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Rând 2: macronutrienți
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _macroText(
                          context,
                          label: 'P',
                          value: (protein ?? 0) * grams! / 100,
                          color: MacroColors.proteins,
                        ),
                        _macroText(
                          context,
                          label: 'C',
                          value: (carbohydrates ?? 0) * grams! / 100,
                          color: MacroColors.carbs,
                        ),
                        _macroText(
                          context,
                          label: 'G',
                          value: (fat ?? 0) * grams! / 100,
                          color: MacroColors.fats,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              nutritionScore != NutritionScore.UNKNOWN ? Padding(
                padding: const EdgeInsets.only(top: 6, right: 20),
                child: Image(
                  image: AssetImage(nutritionScore!.iconPath),
                  width: 22,
                  height: 22,
                ),
              ) : const SizedBox.shrink(),
            ],
          ),

          // if (nutritionScore != null)
          //   if(nutritionScore != NutritionScore.UNKNOWN)
          //     Image(
          //       image: AssetImage(nutritionScore!.iconPath),
          //       width: 16,
          //       height: 16,
          //     )
          // else
          //   const SizedBox.shrink()
        ),
      ),
    );
  }
}
