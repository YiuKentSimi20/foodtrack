import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/date_helper.dart';
import 'package:frontend_flutter/presentation/widgets/line_chart_card.dart';
import '../../core/api_client.dart';
import '../../core/enums/measurement_range.dart';
import '../../core/token_storage.dart';
import '../../features/masuratori/data/masuratori_repository.dart';
import '../../features/masuratori/models/masuratoare_greutate_dto.dart';
import '../widgets/period_selector.dart';

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
  MeasurementRange _range = MeasurementRange.sevenDays;
  DateTimeRange? _customRange;
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 6)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _repo = MasuratoriRepository(apiClient: ApiClient(TokenStorage()));
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _repo.fetchGreutate();
      list.sort((a, b) => b.dataMasuratoare.compareTo(a.dataMasuratoare));
      setState(() => _history = list);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Greutate (kg)'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Data: ${_fmtDate(selected)}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final p = await showDatePicker(
                        context: ctx2,
                        initialDate: selected,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (p != null) {
                        selected = p;
                        setSt(() {});
                      }
                    },
                    child: const Text('Schimbă'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Anulează'),
            ),
            ElevatedButton(
              onPressed: () async {
                final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
                if (v == null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Valoare invalidă')),
                  );
                  return;
                }
                try {
                  await _repo.createGreutate(
                    greutateKg: v,
                    dataMasuratoare: selected,
                  );
                  Navigator.pop(ctx, true);
                } catch (e) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Eroare: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Adaugă'),
            ),
          ],
        ),
      ),
    );

    if (res == true) {
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Măsurătoare adăugată cu succes')),
      );
    }
  }

  List<FlSpot> _spotsFrom(
    List<MasuratoareGreutateDto> days,
    double Function(MasuratoareGreutateDto d) picker,
  ) {
    return List.generate(days.length, (i) {
      final y = picker(days[i]);
      return FlSpot(i.toDouble(), y.isFinite ? y : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final latest = _history.isNotEmpty ? _history.first : null;

    final chartMeasurementDays = _history.reversed
        .where(
          (m) => DateHelper.isDateInRange(m.dataMasuratoare, _selectedRange),
        )
        .toList();

    final measurementSpots = _spotsFrom(
      chartMeasurementDays,
      (m) => m.greutateKg,
    );

    final evolutieKg = measurementSpots.isEmpty
        ? 0
        : measurementSpots.last.y - measurementSpots.first.y;

    final evolutieText = evolutieKg == 0
        ? 'fără schimbare'
        : evolutieKg > 0
            ? 'Ai crescut cu ${evolutieKg.toStringAsFixed(1)} kg'
            : 'Ai scazut cu ${(-evolutieKg).toStringAsFixed(1)} kg';

    return Scaffold(
      appBar: AppBar(title: const Text('Greutate')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.monitor_weight_outlined),
                        ),
                        title: const Text('Ultima măsurătoare'),
                        subtitle: Text(
                          latest != null
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
                    Text('Grafic evoluție', style: Theme.of(context).textTheme.titleMedium),

                    PeriodSelector(
                      selectedRange: _range,
                      onChanged: (range) {
                        setState(() {
                          _range = range;

                          _selectedRange = switch (range) {
                            MeasurementRange.sevenDays => DateTimeRange(
                              start: DateTime.now().subtract(
                                const Duration(days: 6),
                              ),
                              end: DateTime.now(),
                            ),
                            MeasurementRange.month => DateTimeRange(
                              start: DateTime.now().subtract(
                                const Duration(days: 30),
                              ),
                              end: DateTime.now(),
                            ),
                            MeasurementRange.all => DateTimeRange(
                              start: _history.isNotEmpty
                                  ? _history.last.dataMasuratoare
                                  : DateTime.now(),
                              end: DateTime.now(),
                            ),
                            _ => _selectedRange,
                          };
                        });
                      },
                      onCustomTap: () async {
                        final now = DateTime.now();
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: now,
                          initialDateRange:
                              _customRange ??
                              DateTimeRange(
                                start: now.subtract(const Duration(days: 6)),
                                end: now,
                              ),
                        );

                        if (picked != null) {
                          setState(() {
                            _customRange = picked;
                            _selectedRange = _customRange!;
                            _range = MeasurementRange.custom;
                          });
                        }
                      },
                    ),

                    LineChartCard(
                      title: 'Greutate',
                      color: Colors.blueAccent,
                      spots: measurementSpots,
                      days: chartMeasurementDays
                          .map((m) => m.dataMasuratoare)
                          .toList(),
                      unit: 'kg',
                      message: evolutieText,
                      minIsZero: false,
                    ),

                    const SizedBox(height: 24),
                    Text('Istoric măsurători', style: Theme.of(context).textTheme.titleMedium),
                    _history.isEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Niciun istoric',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                        : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                  ],
                ),
              ),
            ),
    );
  }
}
