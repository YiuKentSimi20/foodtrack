import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../../mese/data/masa_repository.dart';
import '../../mese/models/categorie_masa_dto.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  final List<_EditableCategory> _items = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;
  late final MasaRepository _repo;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = MasaRepository(apiClient: ApiClient(tokenStorage));
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cats = await _repo.fetchAllCategoriiMasa();
      _items
        ..clear()
        ..addAll(cats.map((c) => _EditableCategory.fromDto(c)));
      setState(() {});
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });

    // actualizează numarOrdine în funcție de poziție
    final updated = List<CategorieMasaDto>.generate(_items.length, (i) {
      final it = _items[i];
      return CategorieMasaDto(
        id: it.id,
        nume: it.name.trim().isEmpty ? 'Categorie ${it.id}' : it.name.trim(),
        numarOrdine: i,
        isActive: it.isActive,
      );
    });

    try {
      await _repo.updateCategoriiMasa(updated);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrare categorii mese'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Salvează', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Trage pentru a reordona. Schimbă numele sau dezactivează/activează.'),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _items.length,
                onReorder: _onReorder,
                buildDefaultDragHandles: false,
                itemBuilder: (context, index) {
                  final it = _items[index];
                  return Card(
                    key: ValueKey(it.id),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: it.name,
                              decoration: const InputDecoration(
                                labelText: 'Nume categorie',
                                border: InputBorder.none,
                              ),
                              onChanged: (v) => it.name = v,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              const Text('Activ', style: TextStyle(fontSize: 12)),
                              Switch(
                                value: it.isActive,
                                onChanged: (v) => setState(() => it.isActive = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

class _EditableCategory {
  final int id;
  String name;
  bool isActive;

  _EditableCategory({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory _EditableCategory.fromDto(CategorieMasaDto dto) {
    return _EditableCategory(
      id: dto.id,
      name: dto.nume,
      isActive: dto.isActive,
    );
  }
}