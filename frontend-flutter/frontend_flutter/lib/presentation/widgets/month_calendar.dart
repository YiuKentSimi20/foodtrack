import 'package:flutter/material.dart';

class MonthCalendar extends StatefulWidget {
  final Map<String, double?> caloriesByDay; // key: yyyy-MM-dd
  final Function(DateTime) onDaySelected;
  final DateTime initialMonth;

  const MonthCalendar({
    super.key,
    required this.caloriesByDay,
    required this.onDaySelected,
    required this.initialMonth,
  });

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialMonth.year, widget.initialMonth.month);
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<DateTime> _getDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final daysToAdd = first.weekday - 1;
    final firstDay = first.subtract(Duration(days: daysToAdd));

    return List.generate(
      42,
          (i) => firstDay.add(Duration(days: i)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    final allDays = _getDaysInMonth(_currentMonth);
    const dayNames = ['Dum', 'Lun', 'Mar', 'Mie', 'Joi', 'Vin', 'Sâm'];

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header luna
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                    });
                  },
                ),
                Text(
                  'Aprilie 2026', // TODO: format luna an
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                    });
                  },
                ),
              ],
            ),
          ),
          // Zi-urile săptămânii
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: dayNames
                  .map((d) => SizedBox(width: 40, child: Center(child: Text(d))))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Grid cu zilele lunii
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: allDays.length,
              itemBuilder: (context, index) {
                final day = allDays[index];
                final isCurrentMonth = day.month == _currentMonth.month;
                final dayKey = _fmt(day);
                final kcal = widget.caloriesByDay[dayKey] ?? 0;
                final maxKcal = 2500.0;
                final progress = (kcal / maxKcal).clamp(0.0, 1.0);

                return GestureDetector(
                  onTap: isCurrentMonth
                      ? () {
                    widget.onDaySelected(day);
                    Navigator.pop(context);
                  }
                      : null,
                  child: Opacity(
                    opacity: isCurrentMonth ? 1.0 : 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                value: isCurrentMonth ? progress : 0,
                                strokeWidth: 2,
                                backgroundColor: accent.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(accent),
                              ),
                            ),
                            Text(
                              day.day.toString(),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isCurrentMonth ? '${kcal.toStringAsFixed(0)}' : '-',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}