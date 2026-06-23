import 'package:flutter/material.dart';
import 'package:frontend_flutter/presentation/my_alimente_page.dart';
import 'package:frontend_flutter/core/date_formater.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';
import '../features/auth/data/profile_repository.dart';
import '../features/auth/models/date_personale_response.dart';
import 'admin/admin_validate_alimente_page.dart';
import 'edit_personal_data_page.dart';
import 'health_connect_settings_page.dart';
import 'login_page.dart';
import '../main.dart';
import 'manage_categories_page.dart';
import 'measurements/measurements_overview_page.dart';
import 'obiective/obiective_page.dart';

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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (confirmContext) => AlertDialog(
        title: const Text('Confirmare logout'),
        content: Text(
          'Sigur vrei să te deloghezi? Aceasta va șterge toate datele stocate local și va reveni la ecranul de login.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(confirmContext).pop(false),
            child: const Text('Renunță'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(confirmContext).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

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
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String bmrClassification(double? bmr) {
    if (bmr == null) return 'N/A';
    if (bmr < 18.5) return 'Subponderal';
    if (bmr < 25) return 'Normal';
    if (bmr < 30) return 'Supraponderal';
    return 'Obezitate';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : _data == null
          ? const Center(child: Text('Nu există date'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _data!.username ?? 'username',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_data!.varsta.toString()} ani, ${_data?.nivelActivitate?.displayName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Text(
                  'IMC (indice masă corporală)\n${_data!.bmi?.toStringAsFixed(2)} kg/m2 - ${bmrClassification(_data?.bmi)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'BMR (rata metabolică bazală)\n${_data!.bmr?.toStringAsFixed(0)} kcal/zi',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'TDEE (necesar caloric pentru menținere)\n${_data!.tdee?.toStringAsFixed(0)} kcal/zi',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => EditPersonalDataPage(
                          initialBirthDate: DateTime.parse(
                            _data!.dataNasterii!,
                          ),
                          initialGender: _data?.gen,
                          initialActivityLevel: _data!.nivelActivitate,
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MeasurementsOverviewPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.stacked_line_chart),
                  label: const Text('Măsurători'),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ObiectivePage()),
                    );
                  },
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Obiective'),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    final changed = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => const ManageCategoriesPage(),
                      ),
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
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminValidateAlimentePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Validare alimente'),
                  ),
                ],

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HealthConnectSettingsPage(),
                      ),
                    );
                  },
                  icon: const Image(
                    image: AssetImage('assets/icons/health_connect_logo.png'),
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Health Connect'),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCF0026),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
}

class MyFoodsPage {
  const MyFoodsPage();
}
