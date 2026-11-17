/// Viewer copy, taken from design/screens/light/Viewer.html, except [empty]
/// and [loadFailed]: the design has no empty or failure state.
abstract final class ViewerStrings {
  static const close = 'إغلاق';
  static const fontSize = 'حجم الخط';
  static const explanationTab = 'الشرح';
  static const pdfTab = 'الكتاب PDF';
  static const solutionsTab = 'الحلول';
  static const sectionWord = 'القسم';
  static const ofWord = 'من';
  static const previous = 'السابق';
  static const explainSection = 'اشرحلي هذا القسم';
  static const next = 'التالي';

  static const empty = 'لا يوجد شرح لهذا الدرس';
  static const loadFailed = 'تعذّر فتح الدرس';

  static String sectionCounter(int position, int total) => '$sectionWord $position $ofWord $total';
}
