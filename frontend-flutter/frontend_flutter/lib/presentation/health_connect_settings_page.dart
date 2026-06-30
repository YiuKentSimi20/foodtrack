import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/health_service.dart';
import 'package:frontend_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/token_storage.dart';
import '../core/api_client.dart';
import '../features/activitate/data/activitate_repository.dart';
import 'package:health/health.dart';

class HealthConnectSettingsPage extends StatefulWidget {
  const HealthConnectSettingsPage({super.key});

  @override
  State<HealthConnectSettingsPage> createState() =>
      _HealthConnectSettingsPageState();
}

class _HealthConnectSettingsPageState extends State<HealthConnectSettingsPage> {
  late final ActivitateRepository _repo;
  late final HealthConnectService _healthConnectService;
  late final SharedPreferences _prefs;
  bool _syncing = false;
  bool _enabled = false;
  DateTime? _lastSync;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = ActivitateRepository(apiClient: apiClient);
    _healthConnectService = HealthConnectService();
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = _prefs.getBool('health_connect_enabled') ?? false;
      final lastSyncStr = _prefs.getString('health_connect_last_sync');
      _lastSync = lastSyncStr != null ? DateTime.parse(lastSyncStr) : null;
      _loading = false;
    });

    // Dacă e activat, cere permisiuni automat
    if (_enabled) {
      await _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    final health = Health();
    final types = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED];
    final permissions = [HealthDataAccess.READ, HealthDataAccess.READ];

    final requested = await health.requestAuthorization(
      types,
      permissions: permissions,
    );

    if (!requested && mounted) {
      setState(
        () => _error = 'Permisiuni refuzate. Health Connect nu va funcționa.',
      );
      await _prefs.setBool('health_connect_enabled', false);
      setState(() => _enabled = false);
    }
  }

  Future<void> _toggleSync(bool value) async {
    setState(() => _enabled = value);
    await _prefs.setBool('health_connect_enabled', value);

    refreshTrigger.value++;
    if (value) {
      await _requestPermissions();
    } else {
      setState(() => _error = null);
    }
  }

  Future<void> _syncNow() async {
    setState(() {
      _syncing = true;
      _error = null;
    });

    try {
      List<Map<String, dynamic>> healthData = await _healthConnectService
          .syncHistoricalData(daysBack: 30);

      await _repo.syncHealthData(healthData: healthData);

      refreshTrigger.value++;
    } catch (e) {
      setState(() => _error = 'Eroare sincronizare: $e');
    } finally {
      setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Health Connect')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Health Connect')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Sincronizare Health Connect',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Importă pași și calorii arse automat',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Switch(value: _enabled, onChanged: _toggleSync),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ),
          const SizedBox(height: 16),
          if (_lastSync != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ultima sincronizare',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_lastSync!.year.toString().padLeft(4, '0')}-${_lastSync!.month.toString().padLeft(2, '0')}-${_lastSync!.day.toString().padLeft(2, '0')} '
                      '${_lastSync!.hour.toString().padLeft(2, '0')}:${_lastSync!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _enabled && !_syncing ? _syncNow : null,
            icon: _syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: const Text('Sincronizează acum'),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Despre',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Activând sincronizarea, datele despre pași și calorii arse din Health Connect vor fi importate în aplicația FoodTrack. '
                  'Butonul "Sincronizează acum" vă permite să importați manual datele din ultimele 30 de zile.'
                      ' De asemenea, sincronizarea se poate face și din pagina jurnalului odată ce este activată conexiunea.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
