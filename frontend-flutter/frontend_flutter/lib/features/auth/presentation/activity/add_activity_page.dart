import 'package:flutter/material.dart';
import 'package:frontend_flutter/main.dart';
import '../../../../core/api_client.dart';
import '../../../../core/token_storage.dart';
import '../../../activitate/data/activitate_repository.dart';
import '../../../activitate/models/activitate_fizica_dto.dart';

class AddActivityPage extends StatefulWidget {
  final ActivitateFizicaDto activity;
  final DateTime dataActivitate;

  const AddActivityPage({
    required this.activity,
    required this.dataActivitate,
    super.key
  });

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  late final ActivitateRepository _repo;
  late final TextEditingController _durataController;
  late final TextEditingController _notiteController;
  DateTime _selectedDate = DateTime.now();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _durataController = TextEditingController();
    _notiteController = TextEditingController();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = ActivitateRepository(apiClient: apiClient);
  }

  Future<void> _addActivity() async {
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
      await _repo.addActivity(
        idActivity: widget.activity.id!,
        date: widget.dataActivitate,
        durataMin: durata,
        notite: _notiteController.text.isEmpty ? null : _notiteController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activitate adăugată: ${widget.activity.nume}')),
      );

      // întoarce la pagina anterioară cu refresh
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
      appBar: AppBar(title: Text('Adaugă ${widget.activity.nume}')),
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
                    Text('Categorie: ${widget.activity.categorie}', style: Theme.of(context).textTheme.bodySmall),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
          ElevatedButton(
            onPressed: _loading ? null : _addActivity,
            child: _loading ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Adaugă activitate'),
          ),
        ],
      ),
    );
  }
}