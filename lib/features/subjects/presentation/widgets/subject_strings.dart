/// Subject copy. Everything except the empty and failure titles is taken
/// from design/screens/light/Subject.html.
abstract final class SubjectStrings {
  static const back = 'رجوع';
  static const askTutorAboutSubject = 'اسأل المعلّم عن المادة';
  static const separator = ' · ';
  static const unitsNoun = 'وحدات';
  static const lessonsNoun = 'دروس';
  static const bookPagesPrefix = 'صفحات الكتاب';
  static const pageRangeDash = '–';
  static const lastOpened = 'آخر درس فتحته';

  static const emptyTitle = 'لا توجد دروس في هذه المادة بعد';
  static const failureTitle = 'تعذّر فتح دروس المادة';

  static String unitsCount(int count) => '$count $unitsNoun';
  static String lessonsCount(int count) => '$count $lessonsNoun';

  /// Null when the pack has no printed pages for the lesson.
  static String? bookPages(int? from, int? to) {
    if (from == null) return null;
    if (to == null || to == from) return '$bookPagesPrefix $from';
    return '$bookPagesPrefix $from$pageRangeDash$to';
  }

  static String? lessonSubtitle({int? from, int? to, required bool lastOpened}) {
    final pages = bookPages(from, to);
    final parts = [if (pages != null) pages, if (lastOpened) SubjectStrings.lastOpened];
    return parts.isEmpty ? null : parts.join(separator);
  }
}
