class DateFormater {
  static String formatNiceDate(DateTime date) {
    const monthNames = [
      'Ianuarie',
      'Februarie',
      'Martie',
      'Aprilie',
      'Mai',
      'Iunie',
      'Iulie',
      'August',
      'Septembrie',
      'Octombrie',
      'Noiembrie',
      'Decembrie',
    ];

    const weekdayNames = [
      'Luni',
      'Marți',
      'Miercuri',
      'Joi',
      'Vineri',
      'Sâmbătă',
      'Duminică',
    ];

    final weekday = weekdayNames[date.weekday - 1];
    final month = monthNames[date.month - 1];

    return '$weekday, ${date.day} $month';
  }

  static String formatMonthAndYear
      (DateTime date) {
    const monthNames = [
      'Ianuarie',
      'Februarie',
      'Martie',
      'Aprilie',
      'Mai',
      'Iunie',
      'Iulie',
      'August',
      'Septembrie',
      'Octombrie',
      'Noiembrie',
      'Decembrie',
    ];

    final month = monthNames[date.month - 1];
    return '$month ${date.year}';
  }
}
