import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/masuratori/models/nutrition_score.dart';
import 'package:frontend_flutter/presentation/widgets/nutrition_table.dart';
import '../core/api_client.dart';
import '../core/enums/aliment_category.dart';
import '../core/token_storage.dart';
import '../features/aliment/data/aliment_repository.dart';
import '../features/aliment/models/aliment_dto.dart';
import 'barcode_scanner_page.dart';

class CreateAlimentPage extends StatefulWidget {
  final String? initialBarcode;

  const CreateAlimentPage({this.initialBarcode, super.key});

  @override
  State<CreateAlimentPage> createState() => _CreateAlimentPageState();
}

class _CreateAlimentPageState extends State<CreateAlimentPage> {
  final _formKey = GlobalKey<FormState>();

  late final AlimentRepository _repo;
  bool _loading = false;
  String? _error;

  final _productName = TextEditingController();
  final _brands = TextEditingController();
  late final _code = TextEditingController(text: widget.initialBarcode ?? '');
  final _kcal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  final _saturatedFat = TextEditingController();
  final _sugars = TextEditingController();
  final _fiber = TextEditingController();
  final _salt = TextEditingController();

  AlimentCategory _selectedCategory = AlimentCategory.altele;
  NutritionScore _selectedNutriScore = NutritionScore.UNKNOWN;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AlimentRepository(apiClient: ApiClient(tokenStorage));
  }

  double? _parse(String s) {
    final v = s.trim().replaceAll(',', '.');
    if (v.isEmpty) return null;
    return double.tryParse(v);
  }

  void _calculateCalories() {
    final p = _parse(_protein.text);
    final c = _parse(_carbs.text);
    final f = _parse(_fat.text);

    if (p == null || c == null || f == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completează proteine, carbohidrați și grăsimi'),
        ),
      );
      return;
    }

    final kcal = (p * 4) + (c * 4) + (f * 9);
    _kcal.text = kcal.toStringAsFixed(1);
  }

  Future<void> _scanBarcode() async {
    final scannedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        _code.text = scannedCode;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cod scanat: $scannedCode')));
    }
  }

  Future<void> _save() async {
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    final kcal = _parse(_kcal.text);
    final protein = _parse(_protein.text);
    final carbs = _parse(_carbs.text);
    final fat = _parse(_fat.text);
    final saturatedFat = _parse(_saturatedFat.text) ?? 0;
    final sugars = _parse(_sugars.text) ?? 0;
    final fiber = _parse(_fiber.text) ?? 0;
    final salt = _parse(_salt.text) ?? 0;

    if (kcal == null || protein == null || carbs == null || fat == null) {
      setState(
        () => _error = 'Completează caloriile și macronutrienții principali',
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final createdAliment = await _repo.createAliment(
        productName: _productName.text.trim(),
        brands: _brands.text.trim().isEmpty ? null : _brands.text.trim(),
        code: _code.text.trim().isEmpty ? null : _code.text.trim(),
        energyKcal100g: kcal,
        protein100g: protein,
        carbohydrates100g: carbs,
        fat100g: fat,
        saturatedFat100g: saturatedFat,
        sugars100g: sugars,
        fiber100g: fiber,
        salt100g: salt,
        categorie: _selectedCategory.code,
        nutritionScore: _selectedNutriScore.code,
      );

      if (!mounted) return;
      Navigator.of(context).pop<AlimentDto>(createdAliment);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _productName.dispose();
    _brands.dispose();
    _code.dispose();
    _kcal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    _saturatedFat.dispose();
    _sugars.dispose();
    _fiber.dispose();
    _salt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creare aliment')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _productName,
              decoration: const InputDecoration(
                labelText: 'Nume produs *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Introdu un nume' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _brands,
              decoration: const InputDecoration(
                labelText: 'Brand (opțional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Non-editable barcode field with scan button
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Cod de bare',
                border: OutlineInputBorder(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Do nothing or optionally show a tooltip that field is read-only
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _code,
                          readOnly: true,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Apasă pentru a scana',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Scanează cod de bare',
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _loading ? null : _scanBarcode,
                  ),
                  // optional: clear button
                  IconButton(
                    tooltip: 'Șterge cod',
                    icon: const Icon(Icons.clear),
                    onPressed: _loading
                        ? null
                        : () {
                            setState(() {
                              _code.text = '';
                            });
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Notă: Dacă incarci un cod de bare, produsul va fi trimis la validare pentru a fi publicat',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<AlimentCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categorie',
                border: OutlineInputBorder(),
              ),
              items: AlimentCategory.sortedList
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) => setState(
                () => _selectedCategory = v ?? AlimentCategory.altele,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<NutritionScore>(
              initialValue: _selectedNutriScore,
              decoration: const InputDecoration(
                labelText: 'Nutri-Score',
                border: OutlineInputBorder(),
              ),
              items: NutritionScore.sortedList
                  .map(
                    (score) => DropdownMenuItem(
                      value: score,
                      child: Text(score.label),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(
                () => _selectedNutriScore = v ?? NutritionScore.UNKNOWN,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Nutrienți (per 100g)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _kcal,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calorii (kcal) *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Introdu caloriile' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _fat,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grăsimi (g) *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Introdu grăsimile' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _saturatedFat,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grăsimi saturate (g)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _carbs,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Carbohidrați (g) *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Introdu carbohidrații' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _sugars,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Zaharuri (g)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _protein,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Proteine (g) *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Introdu proteinele' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _fiber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Fibre (g)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _salt,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sare (g)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _loading ? null : _calculateCalories,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculează calorii din macro'),
            ),
            const SizedBox(height: 12),

            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],

            ElevatedButton.icon(
              onPressed: _loading ? null : _save,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Crează aliment'),
            ),
          ],
        ),
      ),
    );
  }
}
