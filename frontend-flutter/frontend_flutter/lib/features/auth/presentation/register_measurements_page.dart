import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../data/auth_repository.dart';
import 'objectives/manual_objective_page.dart';

class RegisterMeasurementsPage extends StatefulWidget {

  const RegisterMeasurementsPage({
    super.key,
  });

  @override
  State<RegisterMeasurementsPage> createState() => _RegisterMeasurementsPageState();
}

class _RegisterMeasurementsPageState extends State<RegisterMeasurementsPage> {
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _bodyFat = TextEditingController();

  bool _loading = false;
  String? _error;

  late final AuthRepository _repo;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AuthRepository(
      apiClient: ApiClient(tokenStorage),
      tokenStorage: tokenStorage,
    );
  }

  Future<void> _continue() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final today = DateTime.now();
      final date = '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await _repo.createHeight(
        inaltimeCm: double.parse(_height.text.trim()),
        dataMasuratoare: date,
      );
      await _repo.createWeight(
        greutateKg: double.parse(_weight.text.trim()),
        dataMasuratoare: date,
      );

      final bf = _bodyFat.text.trim();
      if (bf.isNotEmpty) {
        await _repo.createBodyFat(
          grasimeProcent: double.parse(bf),
          dataMasuratoare: date,
        );
      }

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ManualObjectivePage(mode: 'register'),
        ),
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Măsurători')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _height, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Înălțime (cm)')),
          TextField(controller: _weight, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Greutate (kg)')),
          TextField(controller: _bodyFat, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Grăsime corporală (%) - opțional')),
          const SizedBox(height: 16),
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: _loading ? null : _continue,
            child: _loading ? const CircularProgressIndicator() : const Text('Continuă'),
          ),
        ],
      ),
    );
  }
}