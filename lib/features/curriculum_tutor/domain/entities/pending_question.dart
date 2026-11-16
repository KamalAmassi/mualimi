import 'package:equatable/equatable.dart';

enum PendingStatus { pending, answered, failed }

/// A question asked without internet, waiting to be answered.
class PendingQuestion extends Equatable {
  const PendingQuestion({
    this.id,
    required this.question,
    required this.subjectId,
    required this.chunkIds,
    this.lessonId,
    this.status = PendingStatus.pending,
    this.attempts = 0,
    this.createdAt,
  });

  final int? id;
  final String question;
  final String subjectId;
  final String? lessonId;
  final List<int> chunkIds;
  final PendingStatus status;
  final int attempts;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        question,
        subjectId,
        lessonId,
        chunkIds,
        status,
        attempts,
        createdAt
      ];
}
