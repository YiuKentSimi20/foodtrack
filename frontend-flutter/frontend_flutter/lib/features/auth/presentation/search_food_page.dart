import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/auth/presentation/widgets/food_item_card.dart';
import 'package:frontend_flutter/main.dart';
import '../../../core/token_storage.dart';
import '../../../core/api_client.dart';
import '../../aliment/data/aliment_repository.dart';
import '../models/aliment_dto.dart';
import 'aliment_details_page.dart';
import 'create_aliment_page.dart';
import 'manual_entry_page.dart';

class SearchFoodPage extends StatefulWidget {
  final int categorieMasaId;
  final DateTime selectedDate; // data zilei în care adaugi

  const SearchFoodPage({
    super.key,
    required this.categorieMasaId,
    required this.selectedDate,
  });

  @override
  State<SearchFoodPage> createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  List<AlimentDto> _results = [];
  late final AlimentRepository _repo;

  AlimentDto? _selectedAliment;
  final _gramsController = TextEditingController(text: '100');

  double _previewCalories = 0;
  double _previewProtein = 0;
  double _previewCarbs = 0;
  double _previewFat = 0;
  double _previewSalt = 0;
  double _previewFiber = 0;
  double _previewSugars = 0;
  double _previewSaturatedFat = 0;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AlimentRepository(apiClient: ApiClient(tokenStorage));
  }

  Future<void> _search() async {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _repo.searchByName(q);
      setState(() => _results = list);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _updatePreview() {
    final grams = double.tryParse(_gramsController.text.replaceAll(',', '.')) ?? 0;
    final food = _selectedAliment;
    if (food == null || grams <= 0) {
      setState(() {
        _previewCalories = 0;
        _previewProtein = 0;
        _previewCarbs = 0;
        _previewFat = 0;
        _previewSalt = 0;
      });
      return;
    }

    setState(() {
      _previewCalories = (food.energyKcal100g ?? 0) * grams / 100;
      _previewProtein = (food.protein100g ?? 0) * grams / 100;
      _previewCarbs = (food.carbohydrates100g ?? 0) * grams / 100;
      _previewFat = (food.fat100g ?? 0) * grams / 100;
      _previewSalt = (food.salt100g ?? 0) * grams / 100;
    });
  }

  Future<void> _onSelectAliment(AlimentDto aliment) async {
    // Controller local pentru dialog
    final gramsController = TextEditingController(text: '100');

    // Show dialog și folosește StatefulBuilder pentru stare locală (preview + loading)
    final added = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        double previewGrams = 100;
        bool loading = false;
        String? localError;

        void recalc(String text, StateSetter setStateLocal) {
          final grams = double.tryParse(text.replaceAll(',', '.')) ?? 0;
          setStateLocal(() {
            previewGrams = grams;
          });
        }

        return StatefulBuilder(builder: (contextSB, setStateSB) {
          return AlertDialog(
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
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Detalii aliment'),
                  ),
                  FoodItemCard(
                    productName: aliment.productName,
                    brands: aliment.brands,
                    grams: previewGrams,
                    calories: aliment.energyKcal100g,
                    protein: aliment.protein100g,
                    carbohydrates: aliment.carbohydrates100g,
                    category: aliment.categorie,
                    fat: aliment.fat100g,
                  ),
                  const SizedBox(height: 12),

                  // Gramaj input
                  TextField(
                    controller: gramsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Gramaj (g)'),
                    onChanged: (v) => recalc(v, setStateSB),
                  ),
                  const SizedBox(height: 12),

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
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                  final grams = int.tryParse(gramsController.text.trim()) ?? 0;
                  if (grams <= 0) {
                    setStateSB(() => localError = 'Introdu un gramaj valid (>0)');
                    return;
                  }

                  setStateSB(() => loading = true);
                  try {
                    await _repo.addFoodToMeal(
                      categorieMasaId: widget.categorieMasaId,
                      date: widget.selectedDate,
                      grams: grams,
                      idAliment: aliment.id,
                    );

                    // success: închidem dialogul cu true
                    if (mounted) {
                      Navigator.of(dialogContext).pop(true);
                    }
                  } catch (e) {
                    setStateSB(() => localError = e.toString().replaceFirst('Exception: ', ''));
                  } finally {
                    if (mounted) setStateSB(() => loading = false);
                  }
                },
                child: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Adaugă'),
              ),
            ],
          );
        });
      },
    );

    // Dacă dialogul a returnat true => s-a adăugat -> închidem SearchFoodPage cu true
    if (added == true && mounted) {
      refreshTrigger.value++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alimentul a fost adaugat la masa'), // textul pe care vrei să-l afișezi
        ),
      );
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adauga un aliment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Crează aliment nou'),
                subtitle: const Text('Definiți un aliment personalizat'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final createdAliment = await Navigator.of(context).push<AlimentDto>(
                    MaterialPageRoute(builder: (_) => const CreateAlimentPage()),
                  );

                  if (createdAliment != null && mounted) {

                    refreshTrigger.value++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Alimentul a fost creeat'), // textul pe care vrei să-l afișezi
                      ),
                    );
                    _onSelectAliment(createdAliment);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text('Adaugă înregistrare manuală'),
                subtitle: const Text('Introdu manual caloriile și macronutrienții'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final added = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => ManualEntryPage(
                        categorieMasaId: widget.categorieMasaId,
                        selectedDate: widget.selectedDate,
                        categorieNume: 'Înregistrare manuală',
                      ),
                    ),
                  );

                  if (added == true && mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ),
            Row(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(labelText: 'Caută după nume'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _search,
                  child: _loading ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Caută'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final a = _results[i];
                  return ListTile(
                    leading: Icon(
                      a.categorie?.icon ?? Icons.category_outlined,
                      size: 20,
                    ),
                    title: Text(a.productName ?? 'Aliment #${a.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (a.brands != null) Text(a.brands!, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          a.categorie?.label ?? 'Altele',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.add),
                    onTap: () => _onSelectAliment(a),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}