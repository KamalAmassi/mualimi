abstract final class AppRoutes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const grade = '/grade';
  static const download = '/download';
  static const shell = '/shell';
  static const subject = '/subject/:id';
  static const lesson = '/lesson/:id';
  static const viewer = '/viewer/:lessonId';
  static const keyTerms = '/key-terms/:lessonId';
  static const saved = '/saved';

  static String subjectOf(String id) => '/subject/$id';
  static String lessonOf(String id) => '/lesson/$id';
  static String viewerOf(String lessonId, {String? tab}) =>
      tab == null ? '/viewer/$lessonId' : '/viewer/$lessonId?tab=$tab';
  static String keyTermsOf(String lessonId) => '/key-terms/$lessonId';
}
