import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/token_storage.dart';
import '../../features/activitate/data/activitate_repository.dart';
import '../../features/activitate/models/inregistrare_activitate_fizica_response.dart';

class EditActivityPage extends StatefulWidget {
  final InregistrareActivitateFizicaResponse activity;
  final DateTime date;

  const EditActivityPage({
    required this.activity,
    required this.date,
    super.key,
  });

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  late final ActivitateRepository _repo;
  late final TextEditingController _durataController;
  late final TextEditingController _notiteController;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _durataController = TextEditingController(text: widget.activity.durataMin?.toString() ?? '');
    _notiteController = TextEditingController(text: widget.activity.notite ?? '');
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = ActivitateRepository(apiClient: apiClient);
  }

  Future<void> _saveChanges() async {
    final durata = double.tryParse(_durataController.text);
    if (durata == null || durata <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduceți o durată validă în minute')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _repo.updateActivity(
        idActivity: widget.activity.id ?? 0,
        durataMin: durata,
        notite: _notiteController.text.isEmpty ? null : _notiteController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activitate actualizată')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteActivity() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Șterge activitate?'),
        content: Text('Ești sigur că vrei să ștergi "${widget.activity.nume}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Anulează')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Șterge'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);

    try {
      await _repo.deleteActivity(widget.activity.id ?? 0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activitate ștearsă')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _durataController.dispose();
    _notiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editează ${widget.activity.nume}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.activity.nume ?? 'Activitate', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  if (widget.activity.categorie != null) ...[
                    const SizedBox(height: 4),
                    Text('Categorie: ${widget.activity.categorie?.label}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                  if (widget.activity.caloriiArse != null) ...[
                    const SizedBox(height: 4),
                    Text('Calorii arse: ${widget.activity.caloriiArse!.toStringAsFixed(0)} kcal',
                        style: Theme.of(context).textTheme.bodySmall),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Durată
          TextField(
            controller: _durataController,
            decoration: InputDecoration(
              labelText: 'Durată (minute) *',
              prefixIcon: const Icon(Icons.timer),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          // Notite
          TextField(
            controller: _notiteController,
            decoration: InputDecoration(
              labelText: 'Notite (optional)',
              prefixIcon: const Icon(Icons.note),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loading ? null : _saveChanges,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Salvează'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _loading ? null : _deleteActivity,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}