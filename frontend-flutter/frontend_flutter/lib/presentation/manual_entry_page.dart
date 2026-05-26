import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/aliment/data/aliment_repository.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';

class ManualEntryPage extends StatefulWidget {
  final int categorieMasaId;
  final DateTime selectedDate;
  final String categorieNume;

  const ManualEntryPage({
    super.key,
    required this.categorieMasaId,
    required this.selectedDate,
    required this.categorieNume,
  });

  @override
  State<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  final _calories = TextEditingController();
  final _fat = TextEditingController();
  final _carbs = TextEditingController();
  final _fiber = TextEditingController();
  final _protein = TextEditingController();

  bool _loading = false;
  String? _error;
  late final AlimentRepository _repo;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AlimentRepository(apiClient: ApiClient(tokenStorage));
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
      setState(() => _error = 'Completează toti macronutrienții.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _repo.adaugaInregistrareManuala(
        categorieMasaId: widget.categorieMasaId,
        date: widget.selectedDate,
        energyKcal: calories,
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
    final dateLabel = '${widget.selectedDate.year.toString().padLeft(4, '0')}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Înregistrare manuală'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.categorieNume,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text('Data: $dateLabel'),
          const SizedBox(height: 16),

          //TODO: sters gramajul si buton pentru calculat automat calorii
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

          ElevatedButton.icon(
            onPressed: _loading ? null : _save,
            icon: _loading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.save),
            label: const Text('Salvează înregistrarea'),
          ),
        ],
      ),
    );
  }
}