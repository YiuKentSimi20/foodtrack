
import 'package:flutter/material.dart';

class DateHelper {
  /// Întoarce ziua în format LocalDate (fără timp)
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Compară dacă două date sunt aceeași zi
  static bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Întoarce lunea aceleiași săptămâni
  static DateTime getWeekStart(DateTime date) {
    final d = dateOnly(date);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  /// Întoarce duminica aceleiași săptămâni
  static DateTime getWeekEnd(DateTime date) {
    return getWeekStart(date).add(const Duration(days: 6));
  }

  /// Întoarce prima zi a lunii
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Întoarce ultima zi a lunii
  static DateTime getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Întoarce prima zi a anului
  static DateTime getYearStart(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Întoarce ultima zi a anului
  static DateTime getYearEnd(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Calculează numărul săptămânii din an (ISO 8601)
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysIntoYear = date.difference(firstDayOfYear).inDays;
    return ((daysIntoYear + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  /// Total săptămâni din an
  static int getTotalWeeksInYear(int year) {
    final lastDay = DateTime(year, 12, 31);
    return getWeekNumber(lastDay);
  }

  static DateTime getPreviousWeek(DateTime date) {
    return date.subtract(const Duration(days: 7));
  }

  static DateTime getNextWeek(DateTime date) {
    return date.add(const Duration(days: 7));
  }

  static DateTime getPreviousMonth(DateTime date) {
    return DateTime(date.year, date.month - 1, date.day);
  }

  static DateTime getNextMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, date.day);
  }

  /// Eticheta pentru săptămâna curentă
  static String getWeekLabel({DateTime? date}) {
    date ??= DateTime.now();
    final weekNum = getWeekNumber(date);
    final totalWeeks = getTotalWeeksInYear(date.year);
    return 'Săptămâna $weekNum din $totalWeeks';
  }

  /// Eticheta pentru interval (start - end)
  static String getDateRangeLabel(DateTime start, DateTime end) {
    return '${start.day}/${start.month} - ${end.day}/${end.month}/${end.year}';
  }

  static String getDayLabel(DateTime date) {
    const days = ['Luni', 'Marți', 'Miercuri', 'Joi', 'Vineri', 'Sâmbătă', 'Duminică'];
    final dayName = days[date.weekday - 1];
    return dayName;
  }

  /// Eticheta pentru săptămâna curentă: "20/05 - 26/05/2026"
  static String getWeekRangeLabel({DateTime? date}) {
    date ??= DateTime.now();
    final start = getWeekStart(date);
    final end = getWeekEnd(date);
    return getDateRangeLabel(start, end);
  }

  /// Eticheta pentru luna curentă: "Mai"
  static String getMonthLabel({DateTime? date}) {
    date ??= DateTime.now();
    const months = [
      'Ianuarie', 'Februarie', 'Martie', 'Aprilie', 'Mai', 'Iunie',
      'Iulie', 'August', 'Septembrie', 'Octombrie', 'Noiembrie', 'Decembrie'
    ];
    return months[date.month - 1];
  }

  /// Formatare zi/lună (ex: "26/05")
  static String formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  /// Formatare cu zi a săptămânii (ex: "Luni, 26/05")
  static String formatDateWithDay(DateTime date) {
    const days = ['Luni', 'Marți', 'Miercuri', 'Joi', 'Vineri', 'Sâmbătă', 'Duminică'];
    final dayName = days[date.weekday - 1];
    return '$dayName, ${formatShortDate(date)}';
  }

  /// Diferența în zile între două date (ignoring time)
  static int daysBetween(DateTime a, DateTime b) {
    return dateOnly(b).difference(dateOnly(a)).inDays.abs();
  }

  /// Este data azi?
  static bool isToday(DateTime date) {
    return sameDay(date, DateTime.now());
  }

  /// Este data ieri?
  static bool isYesterday(DateTime date) {
    return sameDay(date, DateTime.now().subtract(const Duration(days: 1)));
  }

  /// Este data mâine?
  static bool isTomorrow(DateTime date) {
    return sameDay(date, DateTime.now().add(const Duration(days: 1)));
  }

  /// Eticheta "Azi", "Ieri", "Mâine" sau data
  static String formatRelativeDate(DateTime date) {
    if (isToday(date)) return 'Azi';
    if (isYesterday(date)) return 'Ieri';
    if (isTomorrow(date)) return 'Mâine';
    return formatDayMonthLabel(date);
  }

  static String formatDayMonthLabel(DateTime date) {
    return '${date.day} ${getMonthLabel(date: date)}';
  }

  static bool isDateInRange(DateTime date, DateTimeRange range) {
    final d = dateOnly(date);
    return !d.isBefore(dateOnly(range.start)) && !d.isAfter(dateOnly(range.end));
  }
}