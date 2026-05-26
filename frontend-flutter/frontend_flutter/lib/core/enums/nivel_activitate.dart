
enum NivelActivitate {
  SEDENTAR('SEDENTAR', 'Sedentar', 'Stau mult pe loc sau lucrez de la birou. Nu fac exerciții fizice.'),
  MAI_PUTIN_ACTIV('MAI_PUTIN_ACTIV', 'Mai puțin activ', 'Plimbări ocazionale sau activitate fizică ușoară, dar nu regulată.'),
  ACTIV('ACTIV', 'Activ', 'Fac antrenament de de 2-3 ori pe săptămână, cu exerciții fizice de intensitate moderată.'),
  FOARTE_ACTIV('FOARTE_ACTIV', 'Foarte activ', 'Fac cel puțin 4-5 antrenamente pe săptămână, cu exerciții fizice intense sau de anduranță.'),;

  final String code;
  final String displayName;
  final String description;

  const NivelActivitate(this.code, this.displayName, this.description);

  static NivelActivitate fromCode(String code) {
    try {
      return NivelActivitate.values.firstWhere((e) => e.code == code);
    } catch (_) {
      return NivelActivitate.SEDENTAR;
    }
  }

}