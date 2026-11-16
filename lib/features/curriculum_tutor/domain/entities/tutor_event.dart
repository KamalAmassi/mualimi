import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import 'passage.dart';
import 'tutor_answer.dart';

/// What the tutor pipeline emits for one question.
sealed class TutorEvent extends Equatable {
  const TutorEvent();

  @override
  List<Object?> get props => [];
}

class TutorSubjectUnsupported extends TutorEvent {
  const TutorSubjectUnsupported();
}

/// A ready answer from the pack (question bank or prebuilt), no generation.
class TutorBankAnswer extends TutorEvent {
  const TutorBankAnswer(this.answer, {this.historyId});
  final TutorAnswer answer;
  final int? historyId;

  @override
  List<Object?> get props => [answer, historyId];
}

class TutorOutOfScope extends TutorEvent {
  const TutorOutOfScope();
}

/// The question could not go to the cloud now. The student still gets the
/// passages; `pendingQuestionId` is null when nothing was queued.
class TutorOffline extends TutorEvent {
  const TutorOffline(this.passages, {this.pendingQuestionId});
  final List<Passage> passages;
  final int? pendingQuestionId;

  @override
  List<Object?> get props => [passages, pendingQuestionId];
}

class TutorDailyLimitReached extends TutorEvent {
  const TutorDailyLimitReached(this.passages);
  final List<Passage> passages;

  @override
  List<Object?> get props => [passages];
}

/// A quick action has no prebuilt answer and needs the cloud.
class TutorNeedsInternet extends TutorEvent {
  const TutorNeedsInternet();
}

class TutorToken extends TutorEvent {
  const TutorToken(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

class TutorDone extends TutorEvent {
  const TutorDone(this.answer, {this.historyId, this.passages = const []});
  final TutorAnswer answer;
  final int? historyId;

  /// The passages the answer was written from; follow-ups reuse them.
  final List<Passage> passages;

  @override
  List<Object?> get props => [answer, historyId, passages];
}

class TutorError extends TutorEvent {
  const TutorError(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
