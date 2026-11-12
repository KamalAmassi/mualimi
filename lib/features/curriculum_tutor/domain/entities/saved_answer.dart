import 'package:equatable/equatable.dart';

class SavedAnswer extends Equatable {
  const SavedAnswer({
    this.id,
    required this.subjectId,
    required this.question,
    required this.answer,
    this.lessonId,
    this.sourcePage,
    this.createdAt,
  });

  final int? id;
  final String subjectId;
  final String? lessonId;
  final String question;
  final String answer;
  final int? sourcePage;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, subjectId, lessonId, question, answer, sourcePage, createdAt];
}
