import '../../../../core/constants/app_strings.dart';
import 'key_terms_strings.dart';

/// Lesson hub copy, taken from design/screens/light/Lesson.html and the
/// tutor-unavailable card of LessonMath.html. [askTutorSubtitle] drops the
/// design's offline claim, and [tutorUnavailableTitle] drops its subject.
/// [emptyTitle] is agreed copy: the design has no empty state.
abstract final class LessonHubStrings {
  static const back = 'رجوع';
  static const separator = ' · ';
  static const filesTitle = 'ملفات الدرس';
  static const pdfTitle = 'الدرس من الكتاب';
  static const pdfLabel = 'PDF';
  static const explanationTitle = 'شرح الدرس مكتوباً';
  static const sectionsNoun = 'أقسام';
  static const readyInApp = 'جاهز داخل التطبيق';
  static const keyTermsTitle = KeyTermsStrings.title;
  static const askTutorTitle = 'مش فاهم؟ اسأل المعلّم';
  static const askTutorSubtitle = 'يفتح على هذا الدرس';
  static const tutorUnavailableTitle = AppStrings.smartTutor;
  static const tutorUnavailableBody = 'غير متاح بعد · استخدم الشرح والحلول';
  static const comingSoon = AppStrings.comingSoon;
  static const emptyTitle = 'محتوى هذا الدرس غير متوفر بعد';

  static const _pageRangeDash = '–';

  /// Printed book pages, e.g. `ص 44–49`; null when the lesson has none.
  static String? pages(int? from, int? to) {
    if (from == null) return null;
    final range = to == null || to == from ? '$from' : '$from$_pageRangeDash$to';
    return '${AppStrings.pagesPrefix} $range';
  }

  static String join(Iterable<String?> parts) =>
      parts.whereType<String>().where((p) => p.isNotEmpty).join(separator);

  static String sectionsCount(int count) => '$count $sectionsNoun';

  static String cardsCount(int count) => '$count ${KeyTermsStrings.cardsNoun}';
}
