import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/enums/aliment_category.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';
import '../features/aliment/data/aliment_repository.dart';
import '../features/aliment/models/aliment_dto.dart';
import 'barcode_scanner_page.dart';

class EditAlimentPage extends StatefulWidget {
  final AlimentDto aliment;

  const EditAlimentPage({
    super.key,
    required this.aliment,
  });

  @override
  State<EditAlimentPage> createState() => _EditAlimentPageState();
}

class _EditAlimentPageState extends State<EditAlimentPage> {
  late final AlimentRepository _repo;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _productName;
  late final TextEditingController _brands;
  late final TextEditingController _code;
  late final TextEditingController _kcal;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  late final TextEditingController _saturatedFat;
  late final TextEditingController _sugars;
  late final TextEditingController _fiber;
  late final TextEditingController _salt;

  late AlimentCategory _selectedCategory;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AlimentRepository(apiClient: ApiClient(tokenStorage));
    _formKey = GlobalKey<FormState>();

    _productName = TextEditingController(text: widget.aliment.productName ?? '');
    _brands = TextEditingController(text: widget.aliment.brands ?? '');
    _code = TextEditingController(text: widget.aliment.code ?? '');
    _kcal = TextEditingController(text: widget.aliment.energyKcal100g?.toStringAsFixed(1) ?? '');
    _protein = TextEditingController(text: widget.aliment.protein100g?.toStringAsFixed(1) ?? '');
    _carbs = TextEditingController(text: widget.aliment.carbohydrates100g?.toStringAsFixed(1) ?? '');
    _fat = TextEditingController(text: widget.aliment.fat100g?.toStringAsFixed(1) ?? '');
    _saturatedFat = TextEditingController(text: widget.aliment.saturatedFat100g?.toStringAsFixed(1) ?? '');
    _sugars = TextEditingController(text: widget.aliment.sugars100g?.toStringAsFixed(1) ?? '');
    _fiber = TextEditingController(text: widget.aliment.fiber100g?.toStringAsFixed(1) ?? '');
    _salt = TextEditingController(text: widget.aliment.salt100g?.toStringAsFixed(1) ?? '');

    _selectedCategory = widget.aliment.categorie ?? AlimentCategory.altele;

  }

  double? _parse(String s) {
    if (s.trim().isEmpty) return null;
    return double.tryParse(s.replaceAll(',', '.'));
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
      setState(() => _error = 'Completează caloriile și macronutrienții principali');
      return;
    }

    setState(() => _loading = true);
    try {
      final updated = await _repo.updateAliment(
        id: widget.aliment.id,
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
      );

      if (!mounted) return;
      Navigator.of(context).pop<AlimentDto>(updated);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error ?? 'Eroare la salvare'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _scanBarcode() async {
    final scannedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        _code.text = scannedCode;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cod scanat: $scannedCode')),
      );
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
      appBar: AppBar(
        title: const Text('Editează aliment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _productName,
                decoration: const InputDecoration(labelText: 'Nume aliment *'),
                validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Completează numele' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _brands,
                decoration: const InputDecoration(labelText: 'Brand (opțional)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<AlimentCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categorie'),
                items: AlimentCategory.sortedList
                    .map((c) => DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Text(c.label),
                    ],
                  ),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedCategory = v);
                },
              ),
              const SizedBox(height: 24),

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
              const SizedBox(height: 20),
              const Text('Nutriționali per 100g', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kcal,
                decoration: const InputDecoration(labelText: 'Calorii (kcal) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Completează caloriile' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _protein,
                decoration: const InputDecoration(labelText: 'Proteine (g) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Completează proteinele' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _carbs,
                decoration: const InputDecoration(labelText: 'Carbohidrați (g) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Completează carbohidrații' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fat,
                decoration: const InputDecoration(labelText: 'Grăsimi (g) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                v?.trim().isEmpty ?? true ? 'Completează grăsimile' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _saturatedFat,
                decoration: const InputDecoration(labelText: 'Grăsimi saturate (g)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sugars,
                decoration: const InputDecoration(labelText: 'Zahăr (g)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fiber,
                decoration: const InputDecoration(labelText: 'Fibre (g)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salt,
                decoration: const InputDecoration(labelText: 'Sare (g)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),
              Text(
                'Notă: Dacă modifici alimentul si acesta este public, acesta va fii invalidat si trimis din nou pentru validare.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Salvează'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}