import 'package:flutter/material.dart';

class AppDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  String _formatDate(DateTime date) {
    const monthNames = [
      'Ianuarie', 'Februarie', 'Martie', 'Aprilie', 'Mai', 'Iunie',
      'Iulie', 'August', 'Septembrie', 'Octombrie', 'Noiembrie', 'Decembrie'
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate(BuildContext context) async {

    final now = DateTime.now();
    final initial = value ?? now;

    final picked = await showDatePicker(
      context: context,
      useRootNavigator: true,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
      helpText: 'Alege data',
      cancelText: 'Anulează',
      confirmText: 'Selectează',
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (pickerContext) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _pickDate(pickerContext),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value != null ? _formatDate(value!) : label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}