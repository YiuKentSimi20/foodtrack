import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/masuratori/models/masuratoare_grasime_corporala_dto.dart';
import '../../../../core/api_client.dart';
import '../../../../core/token_storage.dart';
import '../../../masuratori/data/masuratori_repository.dart';
import '../../../masuratori/models/masuratoare_greutate_dto.dart';
import '../../../masuratori/models/masuratoare_inaltime_dto.dart';
import 'weight_detail_page.dart';
import 'height_detail_page.dart';
import 'bodyfat_detail_page.dart';

class MeasurementsOverviewPage extends StatefulWidget {
  const MeasurementsOverviewPage({super.key});
  @override
  State<MeasurementsOverviewPage> createState() => _MeasurementsOverviewPageState();
}

class _MeasurementsOverviewPageState extends State<MeasurementsOverviewPage> {
  late final MasuratoriRepository _repo;
  bool _loading = true;
  String? _error;
  MasuratoareGreutateDto? _latestWeight;
  MasuratoareInaltimeDto? _latestHeight;
  MasuratoareGrasimeCorporalaDto? _latestFat;

  @override
  void initState() {
    super.initState();
    _repo = MasuratoriRepository(apiClient: ApiClient(TokenStorage()));
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _repo.fetchGreutate(),
        _repo.fetchInaltime(),
        _repo.fetchGrasime(),
      ]);
      final weights = results[0] as List<MasuratoareGreutateDto>;
      final heights = results[1] as List<MasuratoareInaltimeDto>;
      final fats = results[2] as List<MasuratoareGrasimeCorporalaDto>;

      weights.sort((a,b) => b.dataMasuratoare.compareTo(a.dataMasuratoare));
      heights.sort((a,b) => b.dataMasuratoare.compareTo(a.dataMasuratoare));
      fats.sort((a,b) => b.dataMasuratoare.compareTo(a.dataMasuratoare));

      setState(() {
        _latestWeight = weights.isNotEmpty ? weights.first : null;
        _latestHeight = heights.isNotEmpty ? heights.first : null;
        _latestFat = fats.isNotEmpty ? fats.first : null;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2,'0')}.${d.month.toString().padLeft(2,'0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Măsurători')),
      body: _loading ? const Center(child: CircularProgressIndicator())
          : _error != null ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.monitor_weight_outlined)),
              title: const Text('Greutate'),
              subtitle: Text(_latestWeight != null ? '${_latestWeight!.greutateKg.toStringAsFixed(1)} kg • ${_fmtDate(_latestWeight!.dataMasuratoare)}' : 'Nicio înregistrare'),
              onTap: () async {
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const WeightDetailPage()),
                );
                _loadAll();
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.height)),
              title: const Text('Înălțime'),
              subtitle: Text(_latestHeight != null ? '${_latestHeight!.inaltimeCm.toStringAsFixed(1)} cm • ${_fmtDate(_latestHeight!.dataMasuratoare)}' : 'Nicio înregistrare'),
              onTap: () async {
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const HeightDetailPage()),
                );
                _loadAll();
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.percent)),
              title: const Text('Procent grăsime corporală'),
              subtitle: Text(_latestFat != null ? '${_latestFat!.procent.toStringAsFixed(1)} % • ${_fmtDate(_latestFat!.dataMasuratoare)}' : 'Nicio înregistrare'),
              onTap: () async {
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const BodyFatDetailPage()),
                );
                _loadAll();
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),
        ],
      ),
    );
  }
}