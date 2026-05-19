import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/macro_colors.dart';

class MacroPie extends StatelessWidget {
  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;
  final double calories;

  const MacroPie({
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
