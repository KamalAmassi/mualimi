import 'package:equatable/equatable.dart';

class QuestionHistoryItem extends Equatable {
  const QuestionHistoryItem({
    this.id,
    required this.subjectId,
    required this.question,
    this.lessonId,
    this.createdAt,
  });

  final int? id;
  final String subjectId;
  final String? lessonId;
  final String question;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, subjectId, lessonId, question, createdAt];
}
