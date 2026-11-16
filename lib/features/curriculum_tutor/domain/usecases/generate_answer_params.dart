import 'package:equatable/equatable.dart';

import '../entities/passage.dart';

/// Everything needed to answer from [passages] with the cloud tutor.
class GenerateAnswerParams extends Equatable {
  const GenerateAnswerParams({
    required this.question,
    required this.subjectId,
    required this.passages,
    this.lessonId,
    this.previousAnswer,
    this.followUpInstruction,
    this.queueWhenOffline = true,
    this.recordHistory = true,
  });

  final String question;
  final String subjectId;
  final String? lessonId;
  final List<Passage> passages;
  final String? previousAnswer;
  final String? followUpInstruction;

  /// Offline questions wait in the queue. Follow-ups and quick actions are
  /// not queued: they only make sense right now.
  final bool queueWhenOffline;
  final bool recordHistory;

  @override
  List<Object?> get props => [
        question,
        subjectId,
        lessonId,
        passages,
        previousAnswer,
        followUpInstruction,
        queueWhenOffline,
        recordHistory,
      ];
}
