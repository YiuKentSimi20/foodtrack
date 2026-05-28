import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/constants/macro_colors.dart';
import 'package:frontend_flutter/core/date_helper.dart';
import 'package:frontend_flutter/core/theme.dart';
import 'package:frontend_flutter/presentation/widgets/line_chart_card.dart';

import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../features/mese/data/masa_repository.dart';
import '../features/mese/models/mese_pe_zi_response.dart';

enum AnalyticsRange { week, month, custom }

class NutritionAnalyticsPage extends StatefulWidget {
  final DateTime initialDate;

  const NutritionAnalyticsPage({required this.initialDate, super.key});

  @override
  State<NutritionAnalyticsPage> createState() => _NutritionAnalyticsPageState();
}

class _NutritionAnalyticsPageState extends State<NutritionAnalyticsPage> {
  late final MasaRepository _repo;

  late DateTime _selectedDay = widget.initialDate;

  AnalyticsRange _range = AnalyticsRange.week;
  DateTimeRange? _customRange;

  bool _loading = true;
  String? _error;
  List<MesePeZiResponse> _mesePeZiResponse = [];

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = MasaRepository(apiClient: apiClient);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final start = _range == AnalyticsRange.week
          ? DateHelper.getWeekStart(_selectedDay)
          : _range == AnalyticsRange.month
          ? DateHelper.getMonthStart(_selectedDay)
          : _customRange?.start ?? _selectedDay;

      final end = _range == AnalyticsRange.week
          ? DateHelper.getWeekEnd(_selectedDay)
          : _range == AnalyticsRange.month
          ? DateHelper.getMonthEnd(_selectedDay)
          : _customRange?.end ?? _selectedDay;

      debugPrint(start.toString());
      debugPrint(end.toString());

      final raport = await _repo.fetchRaport(startDate: start, endDate: end);

      if (!mounted) return;

      setState(() {
        _mesePeZiResponse = raport
            .where((d) => _toDouble(d.totalCaloriiZi) > 0)
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Nu s-au putut încărca datele: $e';
        _loading = false;
      });
    }
  }

  List<FlSpot> _spotsFrom(
    List<MesePeZiResponse> days,
    double Function(MesePeZiResponse d) picker,
  ) {
    return List.generate(days.length, (i) {
      final y = picker(days[i]);
      return FlSpot(i.toDouble(), y.isFinite ? y : 0);
    });
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final caloriesSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.totalCaloriiZi),
    );
    final proteinSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.totalProteineZi),
    );
    final carbsSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.totalCarbohidratiZi),
    );
    final fatSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.totalGrasimiZi),
    );

    final fiberSpots = _spotsFrom(_mesePeZiResponse, (d) => d.fiberTotal ?? 0);

    final saltSpots = _spotsFrom(_mesePeZiResponse, (d) => d.saltTotal ?? 0);

    final sugarsSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => d.freeSugarsTotal ?? 0,
    );

    final satFatSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => d.saturatedFatTotal ?? 0,
    );

    final caloriesTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.obiectivCaloriiZi),
    );
    final proteinTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.obiectivProteineZi),
    );
    final carbsTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.obiectivCarbohidratiZi),
    );
    final fatTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.obiectivGrasimiZi),
    );

    final caloriiNeteSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => _toDouble(d.caloriiNete),
    );

    final fiberTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => d.fiberRecommendedGrams ?? 0,
    );

    final saltTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => d.saltRecommendedGrams ?? 0,
    );

    final sugarsTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => d.freeSugarsRecommendedGrams ?? 0,
    );

    final satFatTargetSpots = _spotsFrom(
      _mesePeZiResponse,
      (d) => d.saturatedFatRecommendedGrams ?? 0,
    );

    final caloriiNeteNeutralSpots = _spotsFrom(_mesePeZiResponse, (d) => 0);

    final zileDeInteres = _mesePeZiResponse
        .map((d) => DateTime.parse(d.data))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Analiză nutrițională')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: SegmentedButton<AnalyticsRange>(
              segments: const [
                ButtonSegment(
                  value: AnalyticsRange.week,
                  label: Text('Săptămână', style: TextStyle(fontSize: 12)),
                  icon: Icon(Icons.calendar_view_week_outlined),
                ),
                ButtonSegment(
                  value: AnalyticsRange.month,
                  label: Text('Lună', style: TextStyle(fontSize: 12)),
                  icon: Icon(Icons.calendar_month_outlined),
                ),
                ButtonSegment(
                  value: AnalyticsRange.custom,
                  label: Text('Manual', style: TextStyle(fontSize: 12)),
                  icon: Icon(Icons.date_range_outlined),
                ),
              ],
              selected: {_range},
              onSelectionChanged: (set) async {
                final selected = set.first;
                // if (selected == _range) return;
                if(selected == AnalyticsRange.custom) {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateRange:
                    _customRange ??
                        DateTimeRange(
                          start: _selectedDay.subtract(const Duration(days: 6)),
                          end: _selectedDay,
                        ),
                  );

                  if (picked != null) {
                    setState(() {
                      _customRange = picked;
                      _range = AnalyticsRange.custom;
                    });
                  }
                } else {
                  setState(() => _range = selected);
                }
                _load();
              },
            ),
          ),

          if (_range != AnalyticsRange.custom) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () => _selectedDay = _range == AnalyticsRange.week
                          ? DateHelper.getPreviousWeek(_selectedDay)
                          : DateHelper.getPreviousMonth(_selectedDay),
                    );
                    _load();
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                ),

                Text(
                  _range == AnalyticsRange.week
                      ? '${DateHelper.getWeekStart(_selectedDay).day} - ${DateHelper.getWeekEnd(_selectedDay).day} ${DateHelper.getMonthLabel(date: _selectedDay)} ${_selectedDay.year}'
                      : '${DateHelper.getMonthLabel(date: _selectedDay)} ${_selectedDay.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                IconButton(
                  onPressed: () {
                    setState(
                      () => _selectedDay = _range == AnalyticsRange.week
                          ? DateHelper.getNextWeek(_selectedDay)
                          : DateHelper.getNextMonth(_selectedDay),
                    );
                    _load();
                  },
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            ),
          ],

          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text(_error!)),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                      children: [
                        LineChartCard(
                          title: 'Calorii',
                          color: Colors.blueAccent,
                          spots: caloriesSpots,
                          targetSpots: caloriesTargetSpots,
                          unit: 'kcal',
                          days: zileDeInteres,
                        ),
                        LineChartCard(
                          title: 'Proteine',
                          color: MacroColors.proteins,
                          spots: proteinSpots,
                          targetSpots: proteinTargetSpots,
                          unit: 'g',
                          days: zileDeInteres,
                        ),
                        LineChartCard(
                          title: 'Carbohidrați',
                          color: MacroColors.carbs,
                          spots: carbsSpots,
                          targetSpots: carbsTargetSpots,
                          unit: 'g',
                          days: zileDeInteres,
                        ),
                        LineChartCard(
                          title: 'Grăsimi',
                          color: MacroColors.fats,
                          spots: fatSpots,
                          targetSpots: fatTargetSpots,
                          unit: 'g',
                          days: zileDeInteres,
                        ),
                        LineChartCard(
                          title: 'Calorii nete',
                          color: Colors.purpleAccent,
                          spots: caloriiNeteSpots,
                          targetSpots: caloriiNeteNeutralSpots,
                          targetTitle: 'Menținere',
                          unit: 'kcal',
                          days: zileDeInteres,
                          minIsZero: false,
                        ),
                        LineChartCard(
                          title: 'Fibre',
                          color: Colors.teal,
                          days: zileDeInteres,
                          spots: fiberSpots,
                          targetSpots: fiberTargetSpots,
                          targetTitle: 'Recomandare',
                          unit: 'g',
                        ),

                        LineChartCard(
                          title: 'Zahăr',
                          color: Colors.orange,
                          days: zileDeInteres,
                          spots: sugarsSpots,
                          targetSpots: sugarsTargetSpots,
                          targetTitle: 'Recomandare',
                          unit: 'g',
                        ),

                        LineChartCard(
                          title: 'Grăsimi saturate',
                          color: Colors.purple,
                          days: zileDeInteres,
                          spots: satFatSpots,
                          targetSpots: satFatTargetSpots,
                          targetTitle: 'Recomandare',
                          unit: 'g',
                        ),

                        LineChartCard(
                          title: 'Sare',
                          color: Colors.redAccent,
                          days: zileDeInteres,
                          spots: saltSpots,
                          targetSpots: saltTargetSpots,
                          targetTitle: 'Recomandare',
                          unit: 'g',
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
