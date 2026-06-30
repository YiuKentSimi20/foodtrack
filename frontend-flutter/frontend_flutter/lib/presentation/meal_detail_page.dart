import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/aliment/data/aliment_repository.dart';
import 'package:frontend_flutter/presentation/search_food_page.dart';
import 'package:frontend_flutter/presentation/widgets/food_item_card.dart';
import 'package:frontend_flutter/presentation/widgets/macro_ring.dart';
import 'package:frontend_flutter/presentation/widgets/nutrition_table.dart';
import 'package:frontend_flutter/main.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';
import '../features/mese/data/masa_repository.dart';
import '../features/mese/models/inregistrare_aliment_response.dart';
import '../features/mese/models/masa_response.dart';
import 'aliment_details_page.dart';
import 'edit_manual_entry_page.dart';



class MealDetailPage extends StatefulWidget {
  final MasaResponse masa; // presupunem că ai deja acest model
  final String categorieNume;


  const MealDetailPage({super.key, required this.masa, required this.categorieNume});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  late MasaResponse _masa;
  late final MasaRepository _repo;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _masa = widget.masa;

    final tokenStorage = TokenStorage();
    _repo = MasaRepository(apiClient: ApiClient(tokenStorage));

  }

  Future<void> _loadMealDetails() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final updated = await _repo.fetchMasaById(_masa.id);
      if (!mounted) return;
      setState(() => _masa = updated);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totals = <Widget>[];
    if (_masa.energyKcalTotal != null) totals.add(Chip(label: Text('${_masa.energyKcalTotal!.toStringAsFixed(0)} kcal')));
    if (_masa.proteinTotal != null) totals.add(Chip(label: Text('P: ${_masa.proteinTotal!.toStringAsFixed(1)}g')));
    if (_masa.carbohydratesTotal != null) totals.add(Chip(label: Text('C: ${_masa.carbohydratesTotal!.toStringAsFixed(1)}g')));
    if (_masa.fatTotal != null) totals.add(Chip(label: Text('F: ${_masa.fatTotal!.toStringAsFixed(1)}g')));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorieNume != null ? '${widget.categorieNume!}' : 'Masa ${_masa.id}'),
        centerTitle: false,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () async {
          final int? categorieId = _masa.categorieMasaId;
          final DateTime selectedDate = DateTime.tryParse(_masa.data) ?? DateTime.now();

          await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => SearchFoodPage(
                categorieMasaId: categorieId ?? 0,
                selectedDate: selectedDate,
              ),
            ),
          );

          refreshTrigger.value++;
          _loadMealDetails();
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalii masă',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    MacroRing(
                      totalKcal: _masa.energyKcalTotal,
                      proteinPercent: _masa.proteinPercent,
                      carbsPercent: _masa.carbohydratesPercent,
                      fatPercent: _masa.fatPercent,
                      proteinGrams: _masa.proteinTotal,
                      carbsGrams: _masa.carbohydratesTotal,
                      fatGrams: _masa.fatTotal,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatNiceDate(DateTime.tryParse(_masa.data) ?? DateTime.now())),
                        Text(_masa.ora ?? ''),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_masa.notite != null)
                      Text('Notițe: ${_masa.notite}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Alimente', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (_masa.alimente.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Niciun aliment în această masă'),
                    )
                  else
                    ..._masa.alimente.map((a) => FoodItemCard(
                      id: a.id,
                      productName: a.productName,
                      brands: a.brands,
                      grams: a.grams,
                      calories: a.energyKcal100g,
                      protein: a.protein100g,
                      carbohydrates: a.carbohydrates100g,
                      fat: a.fat100g,
                      category: a.categorie,
                      nutritionScore: a.nutritionScore,
                      onTap: () async {
                        final isManualEntry = (a.tipInregistrare ?? '') == 'MANUAL';

                        if (isManualEntry) {
                          final edited = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => EditManualEntryPage(aliment: a),
                            ),
                          );

                          if (edited == true) {
                            refreshTrigger.value++;
                            _loadMealDetails();

                          }
                        } else {
                          final modified = await showEditGramajDialog(
                              context, a);
                          if (modified == true) {
                            refreshTrigger.value++;
                            _loadMealDetails();
                          }
                        }
                      },
                    )).toList(),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            // future actions: edit meal, delete item, change gramaj
            NutritionTable(
                firstRowLabel: 'Cantitatea totală a mesei',
                totalGrams: _masa.gramsTotal ?? 0,
                calories: _masa.energyKcalTotal ?? 0,
                fat: _masa.fatTotal,
                saturatedFat: _masa.saturatedFatTotal ?? 0,
                carbohydrates: _masa.carbohydratesTotal ?? 0,
                sugars: _masa.sugarsTotal ?? 0,
                fiber: _masa.fiberTotal ?? 0,
                protein: _masa.proteinTotal ?? 0,
                salt: _masa.saltTotal ?? 0
            ),
            const SizedBox(height:70),
          ],
        ),
      ),
    );
  }
}

  Future<bool?> showEditGramajDialog(BuildContext context, InregistrareAlimentResponse aliment) async {
    final tokenStorage = TokenStorage();
    final repo = AlimentRepository(apiClient: ApiClient(tokenStorage));

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final gramsController = TextEditingController(text: (aliment.grams?.round() ?? 100).toString());
        bool loading = false;
        String? localError;
        double previewGrams = aliment.grams ?? 100;

        void recalc(String v, StateSetter setStateSB) {
          final g = double.tryParse(v.replaceAll(',', '.')) ?? 0;
          setStateSB(() => previewGrams = g);
        }

        return StatefulBuilder(builder: (contextSB, setStateSB) {
          return AlertDialog(
            title: const Text('Modifică gramaj'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(dialogContext).push(
                        MaterialPageRoute(
                          builder: (_) => AlimentDetailsPage(
                            productName: aliment.productName ?? 'Aliment',
                            brands: aliment.brands,
                            code: aliment.code,
                            energyKcal100g: (aliment.energyKcal100g ?? 0).toDouble(),
                            protein100g: (aliment.protein100g?? 0).toDouble(),
                            carbohydrates100g: (aliment.carbohydrates100g ?? 0).toDouble(),
                            fat100g: (aliment.fat100g ?? 0).toDouble(),
                            saturatedFat100g: (aliment.saturatedFat100g ?? 0).toDouble(),
                            sugars100g: (aliment.sugars100g ?? 0).toDouble(),
                            fiber100g: (aliment.fiber100g ?? 0).toDouble(),
                            salt100g: (aliment.salt100g ?? 0).toDouble(),
                            nutritionScore: aliment.nutritionScore,
                            category: aliment.categorie,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Detalii aliment'),
                  ),
                  const SizedBox(height: 12),
                  FoodItemCard(
                    id: aliment.id,
                    productName: aliment.productName,
                    brands: aliment.brands,
                    grams: previewGrams,
                    calories: aliment.energyKcal100g,
                    protein: aliment.protein100g,
                    carbohydrates: aliment.carbohydrates100g,
                    fat: aliment.fat100g,
                    category: aliment.categorie,
                    nutritionScore: aliment.nutritionScore,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: gramsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Gramaj (g)'),
                    onChanged: (v) => recalc(v, setStateSB),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 8),
                    Text(localError!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: loading ? null : () => Navigator.of(dialogContext).pop(false),
                child: const Text('Anulează'),
              ),
              TextButton(
                onPressed: loading
                    ? null
                    : () async {
                  final confirm = await showDialog<bool>(
                    context: dialogContext,
                    builder: (confirmContext) => AlertDialog(
                      title: const Text('Ștergere aliment'),
                      content: Text(
                        'Sigur vrei să ștergi "${aliment.productName ?? 'acest aliment'}" din masă?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(confirmContext).pop(false),
                          child: const Text('Renunță'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.of(confirmContext).pop(true),
                          child: const Text('Șterge'),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  setStateSB(() {
                    loading = true;
                    localError = null;
                  });

                  try {
                    await repo.stergeInregistrareAliment(aliment.id);
                    if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
                  } catch (e) {
                    setStateSB(() => localError = e.toString().replaceFirst('Exception: ', ''));
                  } finally {
                    setStateSB(() => loading = false);
                  }
                },
                child: const Text('Șterge'),
              ),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                  final grams = int.tryParse(gramsController.text.trim()) ?? 0;
                  if (grams <= 0) {
                    setStateSB(() => localError = 'Introdu un gramaj valid (>0)');
                    return;
                  }

                  setStateSB(() {
                    loading = true;
                    localError = null;
                  });

                  try {
                    await repo.modificaGramajInregistrare(idInregistrare: aliment.id, grams: grams);
                    if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
                  } catch (e) {
                    setStateSB(() => localError = e.toString().replaceFirst('Exception: ', ''));
                  } finally {
                    setStateSB(() => loading = false);
                  }
                },
                child: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Salvează'),
              ),
            ],
          );
        });
      },
    );

    return result;
  }

  String _formatNiceDate(DateTime date) {
    const monthNames = [
      'Ianuarie', 'Februarie', 'Martie', 'Aprilie', 'Mai', 'Iunie',
      'Iulie', 'August', 'Septembrie', 'Octombrie', 'Noiembrie', 'Decembrie'
    ];

    const weekdayNames = [
      'Luni', 'Marți', 'Miercuri', 'Joi', 'Vineri', 'Sâmbătă', 'Duminică'
    ];

    final weekday = weekdayNames[date.weekday - 1];
    final month = monthNames[date.month - 1];

    return '$weekday, ${date.day} $month';
  }