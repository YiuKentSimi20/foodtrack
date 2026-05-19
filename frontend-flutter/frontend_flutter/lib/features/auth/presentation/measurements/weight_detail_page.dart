import 'package:flutter/material.dart';
import '../../../../core/api_client.dart';
import '../../../../core/token_storage.dart';
import '../../../masuratori/data/masuratori_repository.dart';
import '../../../masuratori/models/masuratoare_greutate_dto.dart';

class WeightDetailPage extends StatefulWidget {
  const WeightDetailPage({super.key});
  @override
  State<WeightDetailPage> createState() => _WeightDetailPageState();
}

class _WeightDetailPageState extends State<WeightDetailPage> {
  late final MasuratoriRepository _repo;
  bool _loading = true;
  String? _error;
  List<MasuratoareGreutateDto> _history = [];

  @override
  void initState() {
    super.initState();
    _repo = MasuratoriRepository(apiClient: ApiClient(TokenStorage()));
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final list = await _repo.fetchGreutate();
      list.sort((a,b) => b.dataMasuratoare.compareTo(a.dataMasuratoare));
      setState(() => _history = list);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally { setState(() => _loading = false); }
  }

  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2,'0')}.${d.month.toString().padLeft(2,'0')}.${d.year}';

  Future<void> _showAddDialog() async {
    final ctrl = TextEditingController();
    DateTime selected = DateTime.now();

    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setSt) => AlertDialog(
          title: const Text('Adaugă măsurătoare'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Greutate (kg)'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Data: ${_fmtDate(selected)}'),
                  const Spacer(),
                  TextButton(onPressed: () async {
                    final p = await showDatePicker(
                      context: ctx2,
                      initialDate: selected,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (p != null) { selected = p; setSt((){}); }
                  }, child: const Text('Schimbă'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anulează')),
            ElevatedButton(onPressed: () async {
              final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
              if (v == null) {
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Valoare invalidă')));
                return;
              }
              try {
                await _repo.createGreutate(greutateKg: v, dataMasuratoare: selected);
                Navigator.pop(ctx, true);
              } catch (e) {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Eroare: ${e.toString()}')));
              }
            }, child: const Text('Adaugă')),
          ],
        ),
      ),
    );

    if (res == true) {
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Măsurătoare adăugată cu succes'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final latest = _history.isNotEmpty ? _history.first : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Greutate')),
      body: _loading ? const Center(child: CircularProgressIndicator())
          : _error != null ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.monitor_weight_outlined)),
                title: const Text('Ultima măsurătoare'),
                subtitle: Text(latest != null
                    ? '${latest.greutateKg.toStringAsFixed(1)} kg • ${_fmtDate(latest.dataMasuratoare)}'
                    : 'Nicio înregistrare',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Adaugă'),
                  onPressed: _showAddDialog,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _history.isEmpty
                  ? Center(child: Text('Niciun istoric', style: Theme.of(context).textTheme.bodyMedium))
                  : ListView.separated(
                itemCount: _history.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final m = _history[i];
                  return ListTile(
                    title: Text('${m.greutateKg.toStringAsFixed(1)} kg'),
                    subtitle: Text(_fmtDate(m.dataMasuratoare)),
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