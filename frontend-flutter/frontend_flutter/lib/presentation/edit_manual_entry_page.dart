import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/aliment/data/aliment_repository.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';
import '../features/mese/models/inregistrare_aliment_response.dart';

class EditManualEntryPage extends StatefulWidget {
  final InregistrareAlimentResponse aliment;

  const EditManualEntryPage({
    super.key,
    required this.aliment,
  });

  @override
  State<EditManualEntryPage> createState() => _EditManualEntryPageState();
}

class _EditManualEntryPageState extends State<EditManualEntryPage> {
  late final TextEditingController _calories;
  late final TextEditingController _fat;
  late final TextEditingController _carbs;
  late final TextEditingController _fiber;
  late final TextEditingController _protein;

  bool _loading = false;
  String? _error;
  late final AlimentRepository _repo;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AlimentRepository(apiClient: ApiClient(tokenStorage));

    // Preumple cu valorile curente
    _calories = TextEditingController(
      text: (widget.aliment.energyKcal100g != null
          ? widget.aliment.energyKcal100g!.toStringAsFixed(0)
          : '')
          .toString(),
    );
    _fat = TextEditingController(
      text: (widget.aliment.fat100g != null && widget.aliment.grams != null
          ? (widget.aliment.fat100g! * widget.aliment.grams! / 100).toStringAsFixed(1)
          : '')
          .toString(),
    );
    _carbs = TextEditingController(
      text: (widget.aliment.carbohydrates100g != null && widget.aliment.grams != null
          ? (widget.aliment.carbohydrates100g! * widget.aliment.grams! / 100).toStringAsFixed(1)
          : '')
          .toString(),
    );
    _fiber = TextEditingController(
      text: (widget.aliment.fiber100g != null && widget.aliment.grams != null
          ? (widget.aliment.fiber100g! * widget.aliment.grams! / 100).toStringAsFixed(1)
          : '')
          .toString(),
    );
    _protein = TextEditingController(
      text: (widget.aliment.protein100g != null && widget.aliment.grams != null
          ? (widget.aliment.protein100g! * widget.aliment.grams! / 100).toStringAsFixed(1)
          : '')
          .toString(),
    );
  }

  double? _parse(String s) {
    final value = s.trim().replaceAll(',', '.');
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
    });

    final calories = _parse(_calories.text);
    final fat = _parse(_fat.text);
    final carbs = _parse(_carbs.text);
    final fiber = _parse(_fiber.text);
    final protein = _parse(_protein.text);

    if (calories == null || calories < 0) {
      setState(() => _error = 'Introdu caloriile.');
      return;
    }
    if (fat == null || carbs == null || protein == null) {
      setState(() => _error = 'Completează toți macronutrienții.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _repo.modificaInregistrareManuala(
        id: widget.aliment.id,
        calories: calories,
        fat: fat,
        carbohydrates: carbs,
        fiber: fiber ?? 0,
        protein: protein,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  double _calcCaloriesFromMacros({
    required double protein,
    required double carbs,
    required double fat,
  }) {
    return protein * 4 + carbs * 4 + fat * 9;
  }

  void _calculateCalories() {
    final p = _parse(_protein.text);
    final c = _parse(_carbs.text);
    final f = _parse(_fat.text);

    if (p == null || c == null || f == null || p < 0 || c < 0 || f < 0) {
      setState(() => _error = 'Completează corect macronutrienții.');
      return;
    }

    final kcal = _calcCaloriesFromMacros(protein: p, carbs: c, fat: f);
    setState(() {
      _error = null;
      _calories.text = kcal.toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    _calories.dispose();
    _fat.dispose();
    _carbs.dispose();
    _fiber.dispose();
    _protein.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifică înregistrare manuală'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.aliment.productName ?? 'Intrare manuala',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _calories,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Calorii (kcal) *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _protein,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Proteine (g) *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _carbs,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Carbohidrați (g) *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _fat,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Grăsimi (g) *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _fiber,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Fibre (g)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          if (_error != null)
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),

          OutlinedButton.icon(
            onPressed: _loading ? null : _calculateCalories,
            icon: const Icon(Icons.calculate),
            label: const Text('Calculare calorii'),
          ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _loading
                      ? null
                      : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (confirmContext) => AlertDialog(
                        title: const Text('Ștergere înregistrare'),
                        content: const Text(
                          'Sigur vrei să ștergi această înregistrare manuală?',
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

                    setState(() {
                      _loading = true;
                      _error = null;
                    });

                    try {
                      await _repo.stergeInregistrareAliment(widget.aliment.id);
                      if (!mounted) return;
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      setState(() {
                        _error = e.toString().replaceFirst('Exception: ', '');
                      });
                    } finally {
                      if (mounted) {
                        setState(() => _loading = false);
                      }
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Șterge'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: _loading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.save),
                  label: const Text('Salvează modificări'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}