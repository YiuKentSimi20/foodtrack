import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final List<DateTime> daysOfWeek;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final Map<String, double?> caloriesByDay; // key: yyyy-MM-dd
  final Map<String, double?> obiectivByDay; // key: yyyy-MM-dd

  const DaySelector({
    super.key,
    required this.daysOfWeek,
    required this.selectedDay,
    required this.onDaySelected,
    required this.caloriesByDay,
    required this.obiectivByDay,
  });

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _dayName(DateTime d) {
    const names = ['Dum', 'Lun', 'Mar', 'Mie', 'Joi', 'Vin', 'Sâm'];
    return names[d.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(daysOfWeek.length, (i) {
        final day = daysOfWeek[i];
        final isSelected = _fmt(day) == _fmt(selectedDay);
        final dayKey = _fmt(day);
        final isToday = _fmt(day) == _fmt(DateTime.now());
        final kcal = caloriesByDay[dayKey] ?? 0;
        final obiectiv = obiectivByDay[dayKey] ?? 2500;
        final progress = (kcal / obiectiv).clamp(0.0, 1.0);

        final useTodayStyle = isToday;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () => onDaySelected(day),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _dayName(day),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: accent.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            kcal > obiectiv ? Colors.deepOrangeAccent:accent
                        ),
                      ),
                    ),
                    Text(
                      day.day.toString(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? accent : Colors.black87,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? accent : Colors.transparent,
                          border: Border.all(
                            color: isToday || isSelected
                                ? accent
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      }),
    );
  }
}
