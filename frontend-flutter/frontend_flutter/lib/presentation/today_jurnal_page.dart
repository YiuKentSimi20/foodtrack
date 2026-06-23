import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/constants/macro_colors.dart';
import 'package:frontend_flutter/core/date_helper.dart';
import 'package:frontend_flutter/core/health_service.dart';
import 'package:frontend_flutter/features/activitate/data/activitate_repository.dart';
import 'package:frontend_flutter/presentation/profile_page.dart';
import 'package:frontend_flutter/presentation/search_food_page.dart';
import 'package:frontend_flutter/presentation/widgets/macro_ring.dart';
import 'package:frontend_flutter/presentation/widgets/day_selector.dart';
import 'package:frontend_flutter/features/masuratori/models/nutrition_score.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/token_storage.dart';
import '../core/api_client.dart';
import '../features/mese/data/masa_repository.dart';
import '../features/mese/models/mese_pe_zi_response.dart';
import '../main.dart';
import '../core/date_formater.dart';
import '../features/activitate/models/inregistrare_activitate_fizica_response.dart';
import '../features/mese/models/categorie_masa_dto.dart';
import 'activity/edit_activity_page.dart';
import 'activity/search_activity_page.dart';
import 'login_page.dart';
import 'meal_detail_page.dart';
import 'nutrition_analytics_page.dart';
import 'nutrition_day_detail_page.dart';

class TodayJournalPage extends StatefulWidget {
  const TodayJournalPage({super.key});

  @override
  State<TodayJournalPage> createState() => _TodayJournalPageState();
}

class _TodayJournalPageState extends State<TodayJournalPage> {
  late final MasaRepository _masaRepository;
  late final ActivitateRepository _activitateRepository;
  late final HealthConnectService _healthConnectService;
  late final PageController _pageController;
  late final ScrollController _weekScrollController;

  late final SharedPreferences _prefs;
  bool _syncing = false;
  bool _healthEnabled = false;
  DateTime? _lastSync;

  bool _loading = true;
  String? _error;

  DateTime _selectedDay = DateTime.now();
  List<DateTime> _daysOfWeek = [];
  List<CategorieMasaDto> _categorii = [];

  @override
  void initState() {
    super.initState();
    _weekScrollController = ScrollController();
    final tokenStorage = TokenStorage();
    _masaRepository = MasaRepository(apiClient: ApiClient(tokenStorage));
    _activitateRepository = ActivitateRepository(
      apiClient: ApiClient(tokenStorage),
    );
    _healthConnectService = HealthConnectService();
    _initWeek(DateTime.now());

    final todayIndex = _getTodayIndex();
    _selectedDay = _daysOfWeek[todayIndex >= 0 ? todayIndex : 0];
    _pageController = PageController(
      initialPage: todayIndex >= 0 ? todayIndex : 0,
    );

    _initSettings();

    _loadRaport();
    refreshTrigger.addListener(() {
      _loadRaport();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _weekScrollController.dispose();
    refreshTrigger.removeListener(_loadRaport);
    super.dispose();
  }

  Map<String, MesePeZiResponse> _reportsByDay = {}; // key: yyyy-MM-dd

  void _initWeek(DateTime? referenceDay) {
    final day = referenceDay ?? DateTime.now();
    final monday = day.subtract(Duration(days: day.weekday - 1));
    _daysOfWeek = List.generate(7, (i) => monday.add(Duration(days: i)));
    _selectedDay = day;
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _syncHealthConnect() async {
    setState(() {
      _syncing = true;
      _error = null;
    });

    try {
      List<Map<String, dynamic>> healthData = await _healthConnectService
          .syncHistoricalData(daysBack: 30);

      await _activitateRepository.syncHealthData(healthData: healthData);

      await _loadRaport();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Sincronizat cu succes")));
    } catch (e) {
      if (mounted)
        setState(() => _error = 'Eroare sincronizare Health Connect: $e');
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _healthEnabled = _prefs.getBool('health_connect_enabled') ?? false;
      final lastSyncStr = _prefs.getString('health_connect_last_sync');
      _lastSync = lastSyncStr != null ? DateTime.parse(lastSyncStr) : null;
      _loading = false;
    });

    // Dacă e activat, cere permisiuni automat
    if (_healthEnabled) {
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
      setState(() => _healthEnabled = false);
    }
  }

  Future<void> _loadRaport({DateTime? keepDay}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final monday = _daysOfWeek.first;
      final sunday = _daysOfWeek.last;

      final results = await Future.wait([
        _masaRepository.fetchCategoriiMasa(),
        _masaRepository.fetchRaport(startDate: monday, endDate: sunday),
      ]);

      final categorii = results[0] as List<CategorieMasaDto>;
      final reportList = results[1] as List<MesePeZiResponse>;

      final map = <String, MesePeZiResponse>{};
      for (final report in reportList) {
        map[report.data] = report;
      }

      if (mounted) {
        setState(() {
          _categorii = categorii;
          _reportsByDay = map;
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final tokenStorage = TokenStorage();
        await tokenStorage.clearToken();

        if (!mounted) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token expirat. Autentifică-te din nou.'),
          ),
        );

        return;
      }

      if (mounted)
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } catch (e) {
      if (mounted)
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectDay(DateTime day) {
    setState(() => _selectedDay = day);
    final index = _daysOfWeek.indexWhere(
      (d) => _formatDate(d) == _formatDate(day),
    );
    if (index >= 0) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousWeek() {
    final monday = _daysOfWeek.first.subtract(const Duration(days: 7));
    setState(() {
      _daysOfWeek = List.generate(7, (i) => monday.add(Duration(days: i)));
      _selectedDay = monday;
    });
    _loadRaport();
    _pageController.jumpToPage(0);
  }

  void _nextWeek() {
    final monday = _daysOfWeek.first.add(const Duration(days: 7));
    setState(() {
      _daysOfWeek = List.generate(7, (i) => monday.add(Duration(days: i)));
      _selectedDay = monday;
    });
    _loadRaport();
    _pageController.jumpToPage(0);
  }

  Map<int, dynamic> _getMasaByCategorie(DateTime day) {
    final report = _reportsByDay[_formatDate(day)];
    final map = <int, dynamic>{};
    if (report != null) {
      for (final masa in report.mese) {
        if (masa.categorieMasaId != null) {
          map[masa.categorieMasaId!] = masa;
        }
      }
    }
    return map;
  }

  int _getTodayIndex() {
    final today = DateTime.now();
    final todayStr = _formatDate(today);
    return _daysOfWeek.indexWhere((d) => _formatDate(d) == todayStr);
  }

  double _progress(num? actual, num? target) {
    if (actual == null || target == null || target <= 0) return 0.0;
    final value = actual / target;
    if (value.isNaN || value.isInfinite) return 0.0;
    return value.clamp(0.0, 1.0).toDouble();
  }

  String _fmt(num? v, {int decimals = 0}) {
    if (v == null) return '-';
    return v.toStringAsFixed(decimals);
  }

  Widget _macroProgressRow({
    required BuildContext context,
    required String label,
    required num? actual,
    required num? target,
    required Color color,
  }) {
    final p = _progress(actual, target);
    final isOver =
        (actual != null && target != null && target > 0 && actual > target);
    final barColor = isOver ? Colors.red : color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${_fmt(actual, decimals: 0)} / ${_fmt(target, decimals: 0)} g',
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: p,
            minHeight: 10,
            backgroundColor: barColor.withValues(alpha: 0.18),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesCard(
    List<InregistrareActivitateFizicaResponse> activitati,
    DateTime day,
  ) {
    final healthConnectActivities = activitati
        .where((a) => a.sursaDate == 'HEALTH_CONNECT')
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.directions_run, size: 20),
                SizedBox(width: 8),
                Text(
                  'Activități fizice',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),

            !_prefs.getBool('health_connect_enabled')!
                ? SizedBox.shrink()
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Image(
                      image: AssetImage('assets/icons/health_connect_logo.png'),
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      'Health Connect',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: ElevatedButton.icon(
                      icon: const Icon(Icons.sync),
                      label: const Text('Sync'),
                      onPressed: () async {
                        await _syncHealthConnect();
                      },
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.directions_walk,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              healthConnectActivities.isEmpty
                                  ? 'Pași: -'
                                  : healthConnectActivities.first.numarPasi !=
                                        null
                                  ? 'Pași: ${healthConnectActivities.first.numarPasi}'
                                  : 'Pași: -',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              healthConnectActivities.isEmpty
                                  ? 'Calorii: -'
                                  : healthConnectActivities.first.caloriiArse !=
                                        null
                                  ? 'Calorii: ${healthConnectActivities.first.caloriiArse?.toStringAsFixed(0)} kcal'
                                  : 'Calorii: -',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

            const Divider(),
            const SizedBox(height: 12),
            Column(
              children: activitati
                  .where((a) {
                    return a.sursaDate == 'MANUAL';
                  })
                  .map((a) {
                    final title = a.nume ?? a.categorie?.label ?? 'Activitate';
                    final duration = a.durataMin != null
                        ? '${a.durataMin!.toStringAsFixed(0)} min'
                        : null;
                    final kcal = a.caloriiArse != null
                        ? '${a.caloriiArse!.toStringAsFixed(0)} kcal'
                        : null;
                    final subtitleParts = <String>[];
                    if (duration != null) subtitleParts.add(duration);
                    if (kcal != null) subtitleParts.add(kcal);
                    if (a.numarPasi != null)
                      subtitleParts.add('${a.numarPasi} pași');

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      // leading: const Icon(
                      //     Icons.horizontal_rule,
                      //     color: Colors.blue,
                      //   ),
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: subtitleParts.isNotEmpty
                          ? Text(subtitleParts.join(' • '))
                          : null,
                      trailing: Icon(Icons.edit, size: 16),
                      onTap: () async {
                        final modified = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) =>
                                EditActivityPage(activity: a, date: day),
                          ),
                        );
                        if (modified == true && mounted) {
                          _loadRaport();
                        }
                      },
                    );
                  })
                  .toList(),
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adaugă activitate'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                minimumSize: Size(0, 36),
              ),
              onPressed: () async {
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => SearchActivityPage(dataActivitate: day),
                  ),
                );
                if (mounted) {
                  _loadRaport();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: Text('Jurnal - ${DateHelper.formatRelativeDate(_selectedDay)}'),
        backgroundColor: accent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final pickedDay = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDate: _selectedDay
              );

              if (pickedDay != null) {
                setState(() {
                  _selectedDay = pickedDay;
                  _initWeek(_selectedDay);
                });

                _loadRaport();
              }

            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profil',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(accent),
              ),
            )
          : _error != null
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          : _buildContent(accent),
    );
  }

  Widget _buildContent(Color accent) {
    final caloriesByDay = <String, double?>{};
    final obiectivByDay = <String, double?>{};
    for (final day in _daysOfWeek) {
      final raport = _reportsByDay[_formatDate(day)];
      final key = _formatDate(day);
      caloriesByDay[key] = raport?.totalCaloriiZi ?? 0;
      obiectivByDay[key] = raport?.obiectivCaloriiZi ?? 0;
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        Text(DateFormater.formatMonthAndYear(_selectedDay)),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _nextWeek(); // Tragi spre stanga -> Saptamana viitoare
            } else if (details.primaryVelocity! > 0) {
              _previousWeek(); // Tragi spre dreapta -> Saptamana trecuta
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DaySelector(
                    daysOfWeek: _daysOfWeek,
                    selectedDay: _selectedDay,
                    onDaySelected: _selectDay,
                    caloriesByDay: caloriesByDay,
                    obiectivByDay: obiectivByDay,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _previousWeek,
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NutritionAnalyticsPage(
                    initialDate: _selectedDay,
                  )),
                );
              },
              icon: Icon(Icons.ssid_chart, size: 16, color: accent),
              label: Text(
                  'Analiză',
                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),

              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size(0, 32),
                backgroundColor: Colors.white
              )
            ),

            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _nextWeek,
            ),
          ],
        ),

        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedDay = _daysOfWeek[index]);
            },
            itemCount: _daysOfWeek.length,
            itemBuilder: (context, index) {
              return _buildDayContent(_selectedDay, accent);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayContent(DateTime day, Color accent) {
    final raport = _reportsByDay[_formatDate(day)];
    final masaByCategorie = _getMasaByCategorie(day);

    if (raport == null) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Fără date pentru această zi',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRaport,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Header - Total
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.more_horiz_outlined, size: 18),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => NutritionDayDetailPage(day: raport),
                                  ),
                                );
                              },
                              label: Text(
                                'Vezi detalii',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Builder(
                              builder: (context) {
                                final totalKcal = raport.totalCaloriiZi ?? 0;
                                final caloriiRamase =
                                    (raport.obiectivCaloriiZi ?? 0) - totalKcal;
                                final targetKcal =
                                    raport.obiectivCaloriiZi ?? 0;
                                final kcalProgress = _progress(
                                  totalKcal,
                                  targetKcal,
                                );

                                return Row(
                                  children: [
                                    SizedBox(
                                      height: 92,
                                      width: 92,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CircularProgressIndicator(
                                            value: kcalProgress,
                                            strokeWidth: 10,
                                            backgroundColor: accent.withValues(
                                              alpha: 0.18,
                                            ),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  caloriiRamase > 0 ? accent: Colors.deepOrangeAccent,
                                                ),
                                          ),
                                          Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  caloriiRamase
                                                      .abs()
                                                      .toStringAsFixed(0),
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                                Text(
                                                  'kcal ${caloriiRamase >= 0 ? 'rămase' : 'peste'}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.flag_outlined,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Obiectiv: ${_fmt(targetKcal)} kcal',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                          // Text('Obiectiv: ${_fmt(targetKcal)} kcal',
                                          //     style: Theme.of(context).textTheme.bodyMedium),
                                          const SizedBox(height: 6),

                                          Row(
                                            children: [
                                              Icon(
                                                Icons.fastfood_sharp,
                                                color: accent,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Consumat: ${totalKcal.toStringAsFixed(0)} kcal',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_fire_department,
                                                color: Colors.orange,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Activităti fizice: ${raport.caloriiArse != null ? '${raport.caloriiArse!.toStringAsFixed(0)} kcal' : '-'}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Calorii nete: ${raport.caloriiNete != null ? raport.caloriiNete!.toStringAsFixed(0) : '-'} kcal '
                                            '(${raport.caloriiNete! <= 0 ? 'surplus' : 'deficit'})',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            _macroProgressRow(
                              context: context,
                              label: 'Proteine',
                              actual: raport.totalProteineZi,
                              target: raport.obiectivProteineZi,
                              color: MacroColors.proteins,
                            ),
                            const SizedBox(height: 12),
                            _macroProgressRow(
                              context: context,
                              label: 'Carbohidrați',
                              actual: raport.totalCarbohidratiZi,
                              target: raport.obiectivCarbohidratiZi,
                              color: MacroColors.carbs,
                            ),
                            const SizedBox(height: 12),
                            _macroProgressRow(
                              context: context,
                              label: 'Grăsimi',
                              actual: raport.totalGrasimiZi,
                              target: raport.obiectivGrasimiZi,
                              color: MacroColors.fats,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Categoriile meselor
                    ..._categorii.map((categorie) {
                      final masa = masaByCategorie[categorie.id];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    categorie.nume,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    tooltip: 'Adaugă alimente',
                                    onPressed: () async {

                                      final added = await Navigator.of(context)
                                          .push<bool>(
                                            MaterialPageRoute(
                                              builder: (_) => SearchFoodPage(
                                                categorieMasaId: categorie.id,
                                                selectedDate:
                                                    day,
                                              ),
                                            ),
                                          );
                                      if (added == true) {
                                        _loadRaport();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (masa == null) ...[
                                const Text('Niciun aliment adaugat'),
                              ] else ...[
                                GestureDetector(
                                  onTap: () async {
                                    final modified = await Navigator.of(context)
                                        .push<bool>(
                                          MaterialPageRoute(
                                            builder: (_) => MealDetailPage(
                                              masa: masa,
                                              categorieNume: categorie.nume,
                                            ),
                                          ),
                                        );
                                    if (modified == true) {
                                      _loadRaport();
                                    }
                                  },
                                  child: MacroRing(
                                    totalKcal: masa.energyKcalTotal,
                                    proteinPercent: masa.proteinPercent,
                                    carbsPercent: masa.carbohydratesPercent,
                                    fatPercent: masa.fatPercent,
                                    proteinGrams: masa.proteinTotal,
                                    carbsGrams: masa.carbohydratesTotal,
                                    fatGrams: masa.fatTotal,
                                  ),
                                ),
                                const Divider(),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: masa.alimente.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (_, i) {
                                    final aliment = masa.alimente[i];
                                    return ListTile(
                                      dense: true,
                                      leading: Image.asset(
                                        aliment.categorie?.iconPath,
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.contain,
                                      ),
                                      title: Text(
                                        aliment.productName ??
                                            'Aliment #${aliment.id}',
                                      ),
                                      subtitle: Text(
                                        [
                                          if (aliment.grams != null &&
                                              (aliment.productName ?? '') !=
                                                  'Intrare manuala')
                                            '${aliment.grams!.toStringAsFixed(0)} g',
                                          if (aliment.energyKcalTotal != null)
                                            '${aliment.energyKcalTotal!.toStringAsFixed(0)} kcal',
                                        ].join(' • '),
                                      ),
                                      trailing:
                                          aliment.nutritionScore !=
                                              NutritionScore.UNKNOWN
                                          ? Image.asset(
                                              aliment.nutritionScore!.iconPath,
                                              width: 22,
                                              height: 22,
                                              fit: BoxFit.contain,
                                            )
                                          : const SizedBox(
                                              width: 22,
                                              height: 22,
                                            ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 12),
                    _buildActivitiesCard(raport.activitatiFizice, day),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
