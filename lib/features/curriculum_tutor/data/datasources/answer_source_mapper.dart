import '../../domain/entities/answer_source.dart';

/// Rebuilds an [AnswerSource] from the denormalized columns of a stored row;
/// null when the row has no source.
AnswerSource? answerSourceFromColumns({
  required String subjectId,
  required String subjectName,
  required String? lessonId,
  required String? lessonTitle,
  required String? printedPage,
  required int? pdfPage,
}) {
  if (lessonId == null || printedPage == null) return null;
  return AnswerSource(
    subjectId: subjectId,
    subjectName: subjectName,
    lessonId: lessonId,
    lessonTitle: lessonTitle ?? '',
    printedPage: printedPage,
    pdfPage: pdfPage ?? 0,
  );
}
