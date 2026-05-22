import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/constants/macro_colors.dart';
import 'package:frontend_flutter/core/enums/aliment_category.dart';
import 'package:frontend_flutter/features/auth/presentation/profile_page.dart';
import 'package:frontend_flutter/features/auth/presentation/search_food_page.dart';
import 'package:frontend_flutter/features/auth/presentation/widgets/macro_ring.dart';
import 'package:frontend_flutter/features/auth/presentation/widgets/day_selector.dart';
import '../../../core/token_storage.dart';
import '../../../core/api_client.dart';
import '../../../features/mese/data/masa_repository.dart';
import '../../../features/mese/models/mese_pe_zi_response.dart';
import '../../../main.dart';
import '../../activitate/models/inregistrare_activitate_fizica_response.dart';
import '../../mese/models/categorie_masa_dto.dart';
import 'activity/edit_activity_page.dart';
import 'activity/search_activity_page.dart';
import 'login_page.dart';
import 'meal_detail_page.dart';

class TodayJournalPage extends StatefulWidget {
  const TodayJournalPage({super.key});

  @override
  State<TodayJournalPage> createState() => _TodayJournalPageState();
}

class _TodayJournalPageState extends State<TodayJournalPage> {
  late final MasaRepository _masaRepository;
  late final PageController _pageController;
  late final ScrollController _weekScrollController;

  bool _loading = true;
  String? _error;

  DateTime _selectedDay = DateTime.now();
  List<DateTime> _daysOfWeek = [];
  Map<String, MesePeZiResponse> _reportsByDay = {}; // key: yyyy-MM-dd
  List<CategorieMasaDto> _categorii = [];

  @override
  void initState() {
    super.initState();
    _weekScrollController = ScrollController();
    final tokenStorage = TokenStorage();
    _masaRepository = MasaRepository(apiClient: ApiClient(tokenStorage));
    _initWeek();

    final todayIndex = _getTodayIndex();
    _selectedDay = _daysOfWeek[todayIndex >= 0 ? todayIndex : 0];
    _pageController = PageController(
      initialPage: todayIndex >= 0 ? todayIndex : 0,
    );

    _loadRaport();
    refreshTrigger.addListener(() {
      _loadRaport();
    });
  }

  void _initWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _daysOfWeek = List.generate(7, (i) => monday.add(Duration(days: i)));
    _selectedDay = now;
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatNiceDate(DateTime date) {
    const monthNames = [
      'Ianuarie',
      'Februarie',
      'Martie',
      'Aprilie',
      'Mai',
      'Iunie',
      'Iulie',
      'August',
      'Septembrie',
      'Octombrie',
      'Noiembrie',
      'Decembrie',
    ];

    const weekdayNames = [
      'Luni',
      'Marți',
      'Miercuri',
      'Joi',
      'Vineri',
      'Sâmbătă',
      'Duminică',
    ];

    final weekday = weekdayNames[date.weekday - 1];
    final month = monthNames[date.month - 1];

    return '$weekday, ${date.day} $month';
  }

  Future<void> _loadRaport() async {
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

      // Alte erori
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

    final manualActivities = activitati
        .where((a) => a.sursaDate == 'MANUAL')
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
            Column(
              children: healthConnectActivities.map((a) {
                final title = a.nume ?? a.categorie ?? 'Activitate';
                final kcal = a.caloriiArse != null
                    ? '${a.caloriiArse!.toStringAsFixed(0)} kcal'
                    : null;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green.shade50,
                    child: const Icon(Icons.cloud_sync_outlined, color: Colors.blueAccent),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_walk, color: Colors.blueAccent),
                          const SizedBox(width: 4),
                          Text(
                            a.numarPasi != null ? 'Pași: ${a.numarPasi}' : 'Pași: -',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ]
                      ),
                      Row(
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              a.caloriiArse != null ? 'Calorii: ${a.caloriiArse?.toStringAsFixed(0)} kcal' : 'Calorii: -',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ]
                      )

                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(),
            const SizedBox(height: 12),
            Column(
              children: activitati.where((a) { return a.sursaDate == 'MANUAL';}).map((a) {
                final title = a.nume ?? a.categorie ?? 'Activitate';
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
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(Icons.directions_run, color: Colors.blue),
                  ),
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
                        builder: (_) => EditActivityPage(activity: a, date: day),
                      ),
                    );
                    if (modified == true && mounted) {
                      _loadRaport();
                    }
                  },
                );
              }).toList(),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adaugă activitate'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  void dispose() {
    _pageController.dispose();
    _weekScrollController.dispose();
    refreshTrigger.removeListener(_loadRaport);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal - Săptămâna'),
        backgroundColor: accent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: calendar pentru mai târziu
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

  Map<String, double?> _buildCaloriesByDay() {
    final map = <String, double?>{};
    for (final entry in _reportsByDay.entries) {
      map[entry.key] = entry.value.totalCaloriiZi;
    }
    return map;
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
        // Butoane prev/next săptămână + Day selector
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousWeek,
              ),
              Expanded(
                child: DaySelector(
                  daysOfWeek: _daysOfWeek,
                  selectedDay: _selectedDay,
                  onDaySelected: _selectDay,
                  caloriesByDay: caloriesByDay,
                  obiectivByDay: obiectivByDay,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextWeek,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedDay = _daysOfWeek[index]);
            },
            itemCount: _daysOfWeek.length,
            itemBuilder: (context, index) {
              final day = _daysOfWeek[index];
              return _buildDayContent(day, accent);
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
                            Text(
                              'Total ${_formatNiceDate(day)}',
                              style: Theme.of(context).textTheme.titleMedium,
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
                                                  accent,
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
                                                Icons.check,
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
                                      // navigăm la pagina de search; după return true facem refresh
                                      final added = await Navigator.of(context)
                                          .push<bool>(
                                            MaterialPageRoute(
                                              builder: (_) => SearchFoodPage(
                                                categorieMasaId: categorie.id,
                                                selectedDate:
                                                    day, // transmite ziua curentă (din _buildDayContent)
                                              ),
                                            ),
                                          );
                                      if (added == true) {
                                        // reîncarcă raportul (sau poți re-apela doar _loadRaport)
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
                                      leading: Icon(
                                        aliment.categorie?.icon ??
                                            Icons.category_outlined,
                                        color: accent,
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
