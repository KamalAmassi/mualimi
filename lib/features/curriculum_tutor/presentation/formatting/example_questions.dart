import '../../../../core/constants/app_strings.dart';

/// The three questions suggested on an empty chat: the pack's stored
/// questions first, then templates built from the selected lesson or subject.
abstract final class ExampleQuestions {
  static const count = 3;

  static List<String> fill(
    List<String> stored, {
    required String subjectName,
    String? lessonTitle,
  }) {
    final templates = lessonTitle == null
        ? [
            _apply(AppStrings.exampleConcepts, subjectName),
            _apply(AppStrings.exampleStart, subjectName),
            _apply(AppStrings.exampleExplainSubject, subjectName),
          ]
        : [
            _apply(AppStrings.exampleExplainLesson, lessonTitle),
            _apply(AppStrings.exampleSummarizeLesson, lessonTitle),
            _apply(AppStrings.exampleTermsLesson, lessonTitle),
          ];
    return [...stored, ...templates].take(count).toList();
  }

  static String _apply(String template, String name) =>
      template.replaceAll('{name}', name);
}
