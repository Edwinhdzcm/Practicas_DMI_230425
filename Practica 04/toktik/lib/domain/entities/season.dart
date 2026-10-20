/// Temporadas disponibles para los temas visuales/auditivos.
enum Season {
  normal,
  halloween,
  christmas,
  valentine;

  /// Devuelve la temporada que corresponde a una fecha.
  ///
  /// Cada temporada inicia 10 días antes de su celebración:
  ///  - Halloween:     21 oct (10 días antes del 31 oct) -> 2 nov
  ///  - Christmas:     15 dic (10 días antes del 25 dic) -> 6 ene
  ///  - Valentine's:    4 feb (10 días antes del 14 feb) -> 15 feb
  ///  - Normal:        el resto del año
  static Season fromDate(DateTime date) {
    final m = date.month;
    final d = date.day;

    if ((m == 10 && d >= 21) || (m == 11 && d <= 2)) return Season.halloween;
    if ((m == 12 && d >= 15) || (m == 1 && d <= 6)) return Season.christmas;
    if (m == 2 && d >= 4 && d <= 15) return Season.valentine;
    return Season.normal;
  }

  static Season? tryParse(String? name) {
    if (name == null) return null;
    for (final s in Season.values) {
      if (s.name == name) return s;
    }
    return null;
  }
}
