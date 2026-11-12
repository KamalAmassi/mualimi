abstract final class ArabicNormalizer {
  // Harakat (U+064B–U+0652), dagger alef (U+0670) and tatweel (U+0640).
  static final _diacriticsAndTatweel = RegExp('[ً-ْٰـ]');
  static final _whitespace = RegExp(r'\s+');

  static String normalize(String input) {
    return input
        .replaceAll(_diacriticsAndTatweel, '')
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll(_whitespace, ' ')
        .trim();
  }
}
