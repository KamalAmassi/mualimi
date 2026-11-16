// Grade number → Arabic ordinal ("الصف التاسع"), used in pack titles.
abstract final class GradeOrdinals {
  static const Map<int, String> _ordinals = {
    1: 'الأول',
    2: 'الثاني',
    3: 'الثالث',
    4: 'الرابع',
    5: 'الخامس',
    6: 'السادس',
    7: 'السابع',
    8: 'الثامن',
    9: 'التاسع',
    10: 'العاشر',
    11: 'الحادي عشر',
    12: 'الثاني عشر',
  };

  /// The Arabic ordinal for [grade] (1–12); any other value falls back to
  /// the number itself.
  static String of(int grade) => _ordinals[grade] ?? '$grade';
}
