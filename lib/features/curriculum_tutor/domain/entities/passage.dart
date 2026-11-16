import 'package:equatable/equatable.dart';

/// A book passage found by search. `score` is 0..1 (higher is better);
/// `printedPage` is what the student sees, `pdfPage` opens the PDF viewer.
class Passage extends Equatable {
  const Passage({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.lessonId,
    required this.lessonTitle,
    required this.printedPage,
    required this.pdfPage,
    required this.text,
    this.score = 0,
  });

  final int id;
  final String subjectId;
  final String subjectName;
  final String lessonId;
  final String lessonTitle;
  final String printedPage;
  final int pdfPage;
  final String text;
  final double score;

  @override
  List<Object?> get props => [
        id,
        subjectId,
        subjectName,
        lessonId,
        lessonTitle,
        printedPage,
        pdfPage,
        text,
        score
      ];
}
