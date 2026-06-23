import 'package:flutter/material.dart';
import 'package:frontend_flutter/presentation/aliment_details_page.dart';
import 'package:frontend_flutter/presentation/meal_detail_page.dart';
import '../../core/api_client.dart';
import '../../core/token_storage.dart';
import '../../features/aliment/data/aliment_repository.dart';
import '../../features/aliment/models/aliment_dto.dart';
import '../../features/masuratori/models/nutrition_score.dart';

class AdminValidateAlimentePage extends StatefulWidget {
  const AdminValidateAlimentePage({super.key});

  @override
  State<AdminValidateAlimentePage> createState() => _AdminValidateAlimentePageState();
}

class _AdminValidateAlimentePageState extends State<AdminValidateAlimentePage> {
  late final AlimentRepository _repo;
  bool _loading = true;
  String? _error;
  List<AlimentDto> _alimente = [];

  @override
  void initState() {
    super.initState();
    _repo = AlimentRepository(apiClient: ApiClient(TokenStorage()));
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _repo.fetchAlimenteNevalidate();
      if (mounted) setState(() => _alimente = list);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<NutritionScore?> _showNutritionScoreDialog() async {
    return showDialog<NutritionScore?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Selectează Nutri scorul'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final score in NutritionScore.values)
              if (score != NutritionScore.UNKNOWN)
                ListTile(
                  title: Text(score.label),
                  leading: Image(
                    image: AssetImage(score.iconPath),
                    width: 24,
                    height: 24,
                  ),
                  onTap: () => Navigator.of(ctx).pop(score),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAliment(AlimentDto aliment) async {

      final nutritionScore = await _showNutritionScoreDialog();
      if (nutritionScore == null) return; // utilizatorul a închis dialogul fără să selecteze
      setState(() => _loading = true);
    try {
      await _repo.validateAliment(aliment.id, nutritionScore.code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${aliment.productName} validat cu succes')),
        );
        _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validare alimente')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : _alimente.isEmpty
          ? const Center(child: Text('Nu sunt alimente de validat'))
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          itemCount: _alimente.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final aliment = _alimente[i];
            return ListTile(
              leading: Image(
                image: AssetImage(aliment.categorie!.iconPath),
                width: 25,
                height: 25,
              ),
              title: Text(aliment.productName ?? 'Aliment #${aliment.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (aliment.brands != null) Text('Brand: ${aliment.brands}'),
                  Text('Calorii: ${aliment.energyKcal100g?.toStringAsFixed(1) ?? '—'} kcal/100g'),
                  Text('Cod de bare: ${aliment.code ?? '—'}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AlimentDetailsPage(
                            productName: aliment.productName ?? 'Aliment #${aliment.id}',
                            brands: aliment.brands,
                            energyKcal100g: aliment.energyKcal100g ?? 0,
                            protein100g: aliment.protein100g ?? 0,
                            carbohydrates100g: aliment.carbohydrates100g ?? 0,
                            fat100g: aliment.fat100g ?? 0,
                            saturatedFat100g: aliment.saturatedFat100g ?? 0,
                            fiber100g: aliment.fiber100g ?? 0,
                            salt100g: aliment.salt100g ?? 0,
                            sugars100g: aliment.sugars100g ?? 0,
                            category: aliment.categorie,
                            nutritionScore: aliment.nutritionScore,
                          )
                        )
                      );
                    },
                    tooltip: 'Vezi detalii',
                  ),
                  ElevatedButton(
                    onPressed: () => _validateAliment(aliment),
                    child: const Text('Validează'),
                  ),
                ]
              )
            );
          },
        ),
      ),
    );
  }
}