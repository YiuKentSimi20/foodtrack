enum CategorieActivitate {
  CARDIO('CARDIO', 'Cardio'),
  FORTA('FORTA', 'Forță'),
  FLEXIBILITATE('FLEXIBILITATE', 'Flexibilitate'),
  SPORT_DE_ECHIPA('SPORT_DE_ECHIPA', 'Sport de echipă'),
  ACTIVITATI_ZILNICE('ACTIVITATI_ZILNICE', 'Activități zilnice'),;

  final String code;
  final String label;

  const CategorieActivitate(this.code, this.label);

  static CategorieActivitate fromCode(String code) {
    try {
      return values.firstWhere((e) => e.code == code);
    } catch (_) {
      return CategorieActivitate.ACTIVITATI_ZILNICE;
    }
  }

}