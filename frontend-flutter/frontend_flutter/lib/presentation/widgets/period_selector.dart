import 'package:flutter/material.dart';

import '../../core/enums/measurement_range.dart';



class PeriodSelector extends StatelessWidget {
  final MeasurementRange selectedRange;
  final ValueChanged<MeasurementRange> onChanged;
  final VoidCallback? onCustomTap;

  const PeriodSelector({
    super.key,
    required this.selectedRange,
    required this.onChanged,
    this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<MeasurementRange>(
          segments: const [
            ButtonSegment(
              value: MeasurementRange.sevenDays,
              label: Text('7 zile', style: TextStyle(fontSize: 11)),
              icon: Icon(Icons.calendar_view_week_outlined),
            ),
            ButtonSegment(
              value: MeasurementRange.month,
              label: Text('Lună', style: TextStyle(fontSize: 11)),
              icon: Icon(Icons.calendar_month_outlined),
            ),
            ButtonSegment(
              value: MeasurementRange.all,
              label: Text('Toate', style: TextStyle(fontSize: 11)),
              icon: Icon(Icons.all_inclusive),
            ),
            ButtonSegment(
              value: MeasurementRange.custom,
              label: Text('Manual', style: TextStyle(fontSize: 11)),
              icon: Icon(Icons.date_range_outlined),
            ),
          ],
          selected: {selectedRange},
          onSelectionChanged: (set) {
            final selected = set.first;
            onChanged(selected);

            if (selected == MeasurementRange.custom && onCustomTap != null) {
              onCustomTap!();
            }
          },
        ),
      ],
    );
  }
}