/// Key terms copy, taken from design/screens/light/KeyTerms.html, except
/// [empty]: the design has no empty state.
abstract final class KeyTermsStrings {
  static const title = 'مصطلحات الدرس';
  static const back = 'رجوع';
  static const subtitleSeparator = ' · ';
  static const cardsNoun = 'بطاقات';
  static const cardWord = 'البطاقة';
  static const ofWord = 'من';
  static const flipHint = 'اضغط لقلب البطاقة';
  static const previous = 'السابقة';
  static const next = 'التالية';
  static const allTerms = 'كل المصطلحات';

  static const empty = 'لا توجد مصطلحات لهذا الدرس';

  static String subtitle(String? lessonTitle, int count) {
    final cards = '$count $cardsNoun';
    return lessonTitle == null ? cards : '$lessonTitle$subtitleSeparator$cards';
  }

  static String counter(int position, int total) => '$cardWord $position $ofWord $total';
}
