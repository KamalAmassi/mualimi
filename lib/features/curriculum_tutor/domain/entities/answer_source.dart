import 'package:equatable/equatable.dart';

import 'passage.dart';

/// Where an answer came from: subject, lesson and book page.
class AnswerSource extends Equatable {
  const AnswerSource({
    required this.subjectId,
    required this.subjectName,
    required this.lessonId,
    required this.lessonTitle,
    required this.printedPage,
    required this.pdfPage,
  });

  factory AnswerSource.fromPassage(Passage p) => AnswerSource(
        subjectId: p.subjectId,
        subjectName: p.subjectName,
        lessonId: p.lessonId,
        lessonTitle: p.lessonTitle,
        printedPage: p.printedPage,
        pdfPage: p.pdfPage,
      );

  final String subjectId;
  final String subjectName;
  final String lessonId;
  final String lessonTitle;
  final String printedPage;
  final int pdfPage;

  @override
  List<Object?> get props =>
      [subjectId, subjectName, lessonId, lessonTitle, printedPage, pdfPage];
}
