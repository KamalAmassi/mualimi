/// Home copy. Everything except the morning greeting and the two tutor chip
/// labels is taken from design/screens/light/Home.html.
abstract final class HomeStrings {
  static const eveningGreeting = 'مساء الخير';
  static const morningGreeting = 'صباح الخير';
  static const offlineReady = 'أوفلاين · كل الدروس جاهزة';
  static const tutorOnline = 'المعلّم الذكي متاح';
  static const tutorOffline = 'أجوبة جاهزة بدون نت';
  static const continueLabel = 'أكمل من حيث توقفت';
  static const subtitleSeparator = ' · ';
  static const yourSubjects = 'موادّك';
  static const subjectsCountNoun = 'مواد';
  static const availableOffline = 'متاح أوفلاين';
  static const tutorSoon = 'المعلّم قريباً';

  static const arabicGlyph = 'ض';
  static const englishGlyph = 'Aa';
  static const mathGlyph = 'x²';

  static String subjectsCount(int count) => '$count $subjectsCountNoun';
}
