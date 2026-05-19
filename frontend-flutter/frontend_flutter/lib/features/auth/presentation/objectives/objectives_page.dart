import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/main.dart';
import '../../../../core/api_client.dart';
import '../../../../core/token_storage.dart';
import '../../../../core/constants/macro_colors.dart';
import '../../../masuratori/data/masuratori_repository.dart';
import '../../../masuratori/models/masuratoare_greutate_dto.dart';
import '../../../masuratori/models/obiectiv_response.dart';
import '../widgets/objecive_card.dart';
import 'manual_objective_page.dart';

class ObjectivesPage extends StatefulWidget {
  const ObjectivesPage({super.key});

  @override
  State<ObjectivesPage> createState() => _ObjectivesPageState();
}

class _ObjectivesPageState extends State<ObjectivesPage> {
  late final MasuratoriRepository _repo;
  bool _loading = true;
  String? _error;

  List<ObiectivResponse> _history = [];
  MasuratoareGreutateDto? _latestWeight;

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
      final results = await Future.wait([
        _repo.fetchObiective(),
        _repo.fetchGreutate(),
      ]);

      final obiective = results[0] as List<ObiectivResponse>;
      final greutati = results[1] as List<MasuratoareGreutateDto>;

      obiective.sort((a, b) => b.data.compareTo(a.data));
      greutati.sort((a, b) => b.dataMasuratoare.compareTo(a.dataMasuratoare));

      if (!mounted) return;
      setState(() {
        _history = obiective;
        _latestWeight = greutati.isNotEmpty ? greutati.first : null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final current = _history.isNotEmpty ? _history.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Obiective')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ObjectiveCard(
              obiectivTitle: 'Obiectiv curent',
              obiectiv: current!,
            ),
            const SizedBox(height: 16),
            Text('Istoric obiective', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_history.isEmpty)
              const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('Nu există istoric.')))
            else
              ..._history.map((o) {
                return Card(
                  child: ListTile(
                    title: Text(_fmtDate(o.data)),
                    subtitle: Text(
                      'Calorii: ${o.obiectivCaloriiZi.toStringAsFixed(0)} kcal • '
                          'P: ${o.obiectivProteineZi.toStringAsFixed(0)}g • '
                          'C: ${o.obiectivCarbohidratiZi.toStringAsFixed(0)}g • '
                          'G: ${o.obiectivGrasimiZi.toStringAsFixed(0)}g',
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const ManualObjectivePage(mode: 'create')),
          );
          if (changed == true) {
            refreshTrigger.value++;
            _load();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Obiectiv nou'),
      ),
    );
  }

  Widget _macroLegend(Color color, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// CustomPainter pentru 3 arce ce reprezintă procentele macronutrienților
class _MacroPie extends StatelessWidget {
  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;
  final double calories;

  const _MacroPie({
    Key? key,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // normalize dacă suma diferă de 100 -> scala automată (opțional)
    final total = (proteinPercent + carbsPercent + fatPercent).clamp(0.0001, double.infinity);
    final p = proteinPercent / total;
    final c = carbsPercent / total;
    final f = fatPercent / total;

    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: _MacroPiePainter(
              proteinFraction: p,
              carbsFraction: c,
              fatFraction: f,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(calories.toStringAsFixed(0), style: Theme.of(context).textTheme.titleLarge),
              const Text('kcal'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPiePainter extends CustomPainter {
  final double proteinFraction;
  final double carbsFraction;
  final double fatFraction;

  _MacroPiePainter({
    required this.proteinFraction,
    required this.carbsFraction,
    required this.fatFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = 18.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paintBg = Paint()
      ..color = Colors.grey.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 2 * pi, false, paintBg);

    final paintProtein = Paint()
      ..color = MacroColors.proteins
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paintCarbs = Paint()
      ..color = MacroColors.carbs
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paintFat = Paint()
      ..color = MacroColors.fats
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double start = -pi / 2; // start sus
    final sweepP = 2 * pi * proteinFraction;
    final sweepC = 2 * pi * carbsFraction;
    final sweepF = 2 * pi * fatFraction;

    if (sweepP > 0) canvas.drawArc(rect, start, sweepP, false, paintProtein);
    start += sweepP;
    if (sweepC > 0) canvas.drawArc(rect, start, sweepC, false, paintCarbs);
    start += sweepC;
    if (sweepF > 0) canvas.drawArc(rect, start, sweepF, false, paintFat);
  }

  @override
  bool shouldRepaint(covariant _MacroPiePainter oldDelegate) {
    return oldDelegate.proteinFraction != proteinFraction ||
        oldDelegate.carbsFraction != carbsFraction ||
        oldDelegate.fatFraction != fatFraction;
  }
}