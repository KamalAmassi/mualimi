import 'package:equatable/equatable.dart';

/// A prerequisite skill from an earlier grade, with a short mini lesson.
class Skill extends Equatable {
  const Skill({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.title,
    required this.summary,
    required this.miniLesson,
    this.sourcePrintedPage,
  });

  final String id;
  final String subjectId;

  /// The grade the skill originally belongs to.
  final int grade;
  final String title;
  final String summary;

  /// Markdown, written like `sections.body`.
  final String miniLesson;
  final String? sourcePrintedPage;

  @override
  List<Object?> get props =>
      [id, subjectId, grade, title, summary, miniLesson, sourcePrintedPage];
}
