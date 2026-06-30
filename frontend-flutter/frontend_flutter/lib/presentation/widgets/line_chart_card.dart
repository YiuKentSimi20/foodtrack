import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineChartCard extends StatelessWidget {
  final String title;
  final String? targetTitle;
  final Color color;
  final List<FlSpot> spots;
  final List<FlSpot>? targetSpots;
  final List<DateTime> days;
  final String unit;
  final String? message;
  final bool minIsZero;

  const LineChartCard({
    super.key,
    required this.title,
    this.targetTitle,
    required this.color,
    required this.spots,
    this.targetSpots,
    required this.days,
    required this.unit,
    this.message,
    this.minIsZero = true,
  });

  @override
  Widget build(BuildContext context) {
    final allY = <double>[
      ...spots.map((e) => e.y),
      if (targetSpots != null) ...targetSpots!.map((e) => e.y),
    ];

    final double minValue = spots.isEmpty
        ? 0.0
        : spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final double maxValue = spots.isEmpty
        ? 0.0
        : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final double avgValue = spots.isEmpty
        ? 0.0
        : spots.map((s) => s.y).reduce((a, b) => a + b) / spots.length;

    final maxY = allY.isEmpty
        ? 0
        : allY.reduce((a, b) => a > b ? a : b);

    debugPrint(maxY.toString());

    // final minY = minIsZero ? 0 : (allY.isEmpty ? 0 : allY.reduce((a, b) => a < b ? a : b));
    final minY = allY.isEmpty
        ? 0
        : allY.reduce((a, b) => a < b ? a : b);

    double safeMinY = minY.toDouble();
    double safeMaxY = maxY.toDouble();

    if (safeMinY == safeMaxY) {
      safeMinY -= 1.0;
      safeMaxY += 1.0;
    }


    double yRange = safeMaxY - safeMinY;
    double yInterval = yRange / 4;

    if (yInterval <= 0) {
      yInterval = 1.0;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title ($unit)',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: spots.isNotEmpty ? (spots.length - 1).toDouble() : 1,
                  minY: safeMinY,
                  maxY: safeMaxY,
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    // <- ascunde tot textul jos
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 64,
                        interval: yInterval,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (items) {
                        return items.map((it) {
                          final i = it.x.toInt();
                          final date = (i >= 0 && i < days.length)
                              ? days[i]
                              : DateTime.now();
                          return LineTooltipItem(
                            '${date.day}/${date.month}\n${it.y.toStringAsFixed(1)} $unit',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withValues(alpha: 0.12),
                      ),
                    ),
                    if (targetSpots != null)
                      LineChartBarData(
                        spots: targetSpots!,
                        isCurved: true,
                        color: Colors.greenAccent,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(radius: 5, backgroundColor: color),
                const SizedBox(width: 6),
                Text(title, style: TextStyle(fontSize: 12)),

                const SizedBox(width: 12),

                targetSpots != null
                    ? Row(
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.greenAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            targetTitle ?? 'Obiectiv',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // MIN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Min',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        minValue.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // AVG
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Medie',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        avgValue.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // MAX
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Max',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        maxValue.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
