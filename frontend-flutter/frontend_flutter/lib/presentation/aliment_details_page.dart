import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/enums/aliment_category.dart';
import 'package:frontend_flutter/features/aliment/models/detalii_aliment_response.dart';
import 'package:frontend_flutter/presentation/widgets/macro_ring.dart';
import 'package:frontend_flutter/presentation/widgets/nutrition_table.dart';
import 'package:frontend_flutter/features/masuratori/models/nutrition_score.dart';
import '../core/constants/macro_colors.dart';

import '../core/token_storage.dart';
import '../core/api_client.dart';
import '../features/aliment/data/aliment_repository.dart';
import '../features/aliment/models/aliment_dto.dart'; // aliment dto used to build request

class AlimentDetailsPage extends StatefulWidget {
  final double energyKcal100g;
  final double protein100g;
  final double carbohydrates100g;
  final double fat100g;
  final double saturatedFat100g;
  final double fiber100g;
  final double salt100g;
  final double sugars100g;
  final String? productName;
  final String? brands;
  final String? code;
  final NutritionScore? nutritionScore;
  final AlimentCategory? category;

  const AlimentDetailsPage({
    required this.energyKcal100g,
    required this.protein100g,
    required this.carbohydrates100g,
    required this.fat100g,
    required this.saturatedFat100g,
    required this.fiber100g,
    required this.salt100g,
    required this.sugars100g,
    this.productName,
    this.brands,
    this.code,
    this.nutritionScore,
    this.category,
    super.key,
  });

  @override
  State<AlimentDetailsPage> createState() => _AlimentDetailsPageState();
}

class _AlimentDetailsPageState extends State<AlimentDetailsPage> {
  late final AlimentRepository _repo;
  Future<DetaliiAlimentResponse>? _detaliiAliment;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = AlimentRepository(apiClient: apiClient);

    final alimentForRequest = AlimentDto(
      id: 0,
      energyKcal100g: widget.energyKcal100g,
      fat100g: widget.fat100g,
      saturatedFat100g: widget.saturatedFat100g,
      carbohydrates100g: widget.carbohydrates100g,
      protein100g: widget.protein100g,
    );

    // Request backend-calculated details
    _detaliiAliment = _repo.getAlimentDetalii(alimentForRequest);
  }

  // Local fallback macro percent calculation (from per-100g values) if backend fails
  Map<String, double> _localMacroPercent() {
    final pKcal = (widget.protein100g) * 4;
    final cKcal = (widget.carbohydrates100g) * 4;
    final fKcal = (widget.fat100g) * 9;
    final total = pKcal + cKcal + fKcal;
    if (total <= 0) return {'Proteine': 0, 'Carbohidrați': 0, 'Grăsimi': 0};
    return {
      'Proteine': (pKcal / total) * 100,
      'Carbohidrați': (cKcal / total) * 100,
      'Grăsimi': (fKcal / total) * 100,
    };
  }

  double _localCaloriesDensity() {
    // kcal per gram = kcal per 100g / 100
    return widget.energyKcal100g / 100.0;
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.nutritionScore;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalii aliment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<DetaliiAlimentResponse>(
          future: _detaliiAliment,
          builder: (context, snapshot) {
            final hasData = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
            final hasError = snapshot.hasError;
            // Use backend values if available, otherwise fallback to local calcs
            final densitate = hasData ? snapshot.data!.densitateCalorica : _localCaloriesDensity();
            final proteinPercent = hasData ? snapshot.data!.proteinPercent : _localMacroPercent()['Proteine']!;
            final carbsPercent = hasData ? snapshot.data!.carbohydratesPercent : _localMacroPercent()['Carbohidrați']!;
            final fatPercent = hasData ? snapshot.data!.fatPercent : _localMacroPercent()['Grăsimi']!;

            return ListView(
              children: [
                // Header card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName ?? 'Aliment necunoscut',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (widget.brands != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Brand: ${widget.brands}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (widget.category != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Categorie: ${widget.category?.label ?? '-'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Densitate calorica + Nutrition Score
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Densitate calorică', style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                '${(densitate).toStringAsFixed(2)} kcal/g',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (snapshot.connectionState == ConnectionState.waiting)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: LinearProgressIndicator(),
                                ),
                              if (hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Nu s-au putut încărca detaliile (folosind calcule locale).',
                                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nutrition Score', style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    score != NutritionScore.UNKNOWN ?
                                        Image(
                                          image: AssetImage(score!.iconPath),
                                          width: 30,
                                          height: 30,
                                        ) : const Icon(Icons.help_outline, size: 20, color: Colors.grey),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Distribuție macronutrienți - Grafic
                Card(
                  child: MacroRing(
                    totalKcal: widget.energyKcal100g,
                    proteinGrams: widget.protein100g,
                    carbsGrams: widget.carbohydrates100g,
                    fatGrams: widget.fat100g,
                    proteinPercent: proteinPercent,
                    carbsPercent: carbsPercent,
                    fatPercent: fatPercent,
                  ),
                ),
                const SizedBox(height: 20),

                // Tabel nutrițional
                Text('Tabel nutrițional (per 100g)', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                NutritionTable(
                  firstRowLabel: 'Cantitate',
                  totalGrams: 100,
                  calories: widget.energyKcal100g,
                  protein: widget.protein100g,
                  carbohydrates: widget.carbohydrates100g,
                  fat: widget.fat100g,
                  saturatedFat: widget.saturatedFat100g,
                  fiber: widget.fiber100g,
                  salt: widget.salt100g,
                  sugars: widget.sugars100g,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _macroBadge(Color color, String label, String percent) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              percent,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _nutritionalTable(BuildContext context) {
    final rows = [
      ['Calorii', '${widget.energyKcal100g.toStringAsFixed(1)}', 'kcal'],
      ['Proteină', '${widget.protein100g.toStringAsFixed(1)}', 'g'],
      ['Carbohidrați', '${widget.carbohydrates100g.toStringAsFixed(1)}', 'g'],
      ['  din care zaharuri', '${widget.sugars100g.toStringAsFixed(1)}', 'g'],
      ['  din care fibre', '${widget.fiber100g.toStringAsFixed(1)}', 'g'],
      ['Grăsimi', '${widget.fat100g.toStringAsFixed(1)}', 'g'],
      ['  din care saturate', '${widget.saturatedFat100g.toStringAsFixed(1)}', 'g'],
      ['Sare', '${widget.salt100g.toStringAsFixed(1)}', 'g'],
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: List.generate(
            rows.length,
                (i) {
              final row = rows[i];
              final isHeader = i == 0;
              final isSubitem = row[0].startsWith('  ');

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            row[0],
                            style: TextStyle(
                              fontWeight: isHeader ? FontWeight.bold : (isSubitem ? FontWeight.normal : FontWeight.w500),
                              fontSize: isSubitem ? 13 : 14,
                              color: isSubitem ? Colors.grey[700] : null,
                            ),
                          ),
                        ),
                        Text(
                          row[1],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isHeader ? null : 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 30,
                          child: Text(
                            row[2],
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < rows.length - 1) const Divider(height: 1),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}