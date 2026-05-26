import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/enums/aliment_category.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';
import '../features/aliment/data/aliment_repository.dart';
import '../features/aliment/models/aliment_dto.dart';
import 'edit_aliment_page.dart';

class MyAlimentePage extends StatefulWidget {
  const MyAlimentePage({super.key});

  @override
  State<MyAlimentePage> createState() => _MyAlimentePageState();
}

class _MyAlimentePageState extends State<MyAlimentePage> {
  late final AlimentRepository _repo;
  bool _loading = true;
  String? _error;
  List<AlimentDto> _myAlimente = [];
  List<AlimentDto> _filtered = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AlimentRepository(apiClient: ApiClient(tokenStorage));
    _loadMyAlimente();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadMyAlimente() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final alimente = await _repo.fetchAlimenteUtilizator();
      if (mounted) {
        setState(() {
          _myAlimente = alimente;
          _filtered = alimente;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = _myAlimente
          .where((f) =>
      (f.productName?.toLowerCase().contains(q) ?? false) ||
          (f.brands?.toLowerCase().contains(q) ?? false) ||
          (f.categorie?.label.toLowerCase().contains(q) ?? false))
          .toList();
    });
  }

  Future<void> _deleteFood(AlimentDto food) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmă ștergerea'),
        content: Text('Ești sigur că vrei să ștergi "${food.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Anulează'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Șterge'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // TODO: De implementat endpoint de ștergere aliment dacă nu există
      // await _repo.deleteFood(food.id);
      setState(() {
        _myAlimente.removeWhere((f) => f.id == food.id);
        _filtered.removeWhere((f) => f.id == food.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${food.productName} a fost șters')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alimentele mele')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Caută...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (_myAlimente.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_meals_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nu ai creat încă alte alimente',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final food = _filtered[i];
                  return ListTile(
                    leading: Image(
                      image: AssetImage(food.categorie!.iconPath),
                      width: 25,
                      height: 25,
                    ),
                    title: Text(food.productName ?? 'Aliment #${food.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (food.brands != null)
                          Text(food.brands!, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          food.categorie?.label ?? 'Altele',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${food.energyKcal100g?.toStringAsFixed(1)} kcal/100g',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    onTap: () async {
                      final updated = await Navigator.of(context).push<AlimentDto>(
                        MaterialPageRoute(
                          builder: (_) => EditAlimentPage(aliment: food),
                        ),
                      );

                      if (updated != null && mounted) {
                        // Actualizează lista local
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aliment actualizat')),
                        );
                      }

                      await _loadMyAlimente();
                      _onSearchChanged();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}