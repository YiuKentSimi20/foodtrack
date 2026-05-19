import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/auth/presentation/my_alimente_page.dart';
import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../data/profile_repository.dart';
import '../models/date_personale_response.dart';
import 'admin/admin_validate_aliments_page.dart';
import 'edit_personal_data_page.dart';
import 'login_page.dart';
import '../../../main.dart';
import 'manage_categories_page.dart';
import 'measurements/measurements_overview_page.dart';
import 'objectives/objectives_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TokenStorage _tokenStorage;
  late final ProfileRepository _repo;

  bool _loading = true;
  String? _error;
  DatePersonaleResponse? _data;

  @override
  void initState() {
    super.initState();
    _tokenStorage = TokenStorage();
    _repo = ProfileRepository(apiClient: ApiClient(_tokenStorage));
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _repo.getDatePersonale();
      if (!mounted) return;
      setState(() => _data = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await _tokenStorage.clearToken();
    if (!mounted) return;

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : _data == null
          ? const Center(child: Text('Nu există date'))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Username', _data!.username ?? '-'),
          _row('Email', _data!.email ?? '-'),
          _row('Data nașterii', _data!.dataNasterii ?? '-'),
          _row('Vârstă', _data!.varsta?.toString() ?? '-'),
          _row('Gen', _data!.gen ?? '-'),
          _row('Activitate', _data!.nivelActivitate ?? '-'),
          _row('BMI', _data!.bmi?.toStringAsFixed(1) ?? '-'),
          _row('BMR', _data!.bmr?.toStringAsFixed(0) ?? '-'),
          _row('TDEE', _data!.tdee?.toStringAsFixed(0) ?? '-'),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () async {
              final updated = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => EditPersonalDataPage(
                    initialBirthDate: DateTime.parse(_data!.dataNasterii!),
                    initialGender: _data?.gen,
                    initialActivityLevel: _data?.nivelActivitate,
                  ),
                ),
              );

              if (updated == true && context.mounted) {
                await _load();
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text('Modificare date personale'),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyAlimentePage()),
              );
            },
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Alimentele mele'),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MeasurementsOverviewPage()));
            },
            icon: const Icon(Icons.stacked_line_chart),
            label: const Text('Măsurători'),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ObjectivesPage()),
              );
            },
            icon: const Icon(Icons.flag_outlined),
            label: const Text('Obiective'),
          ),

          ElevatedButton.icon(
            onPressed: () async {
              final changed = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const ManageCategoriesPage()),
              );

              if (changed == true && mounted) {
                refreshTrigger.value++;
                _load();
              }
            },
            icon: const Icon(Icons.settings),
            label: const Text('Administrare mese'),
          ),

          if (_data?.rol == 'ADMIN') ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminValidateAlimentsPage()),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Validare alimente'),
            ),
          ],

          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class MyFoodsPage {
  const MyFoodsPage();
}