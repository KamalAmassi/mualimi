import '../../domain/entities/chat_message.dart';
import '../../domain/entities/tutor_event.dart';

/// What each pipeline event does to the answer message it belongs to.
/// Streamed tokens are not handled here: the transcript batches them.
abstract final class TutorEventApplier {
  static ChatMessage apply(ChatMessage message, TutorEvent event) {
    return switch (event) {
      TutorToken() => message,
      TutorBankAnswer(:final answer, :final historyId) => message.copyWith(
          text: answer.text,
          source: answer.source,
          fromBank: answer.fromBank,
          historyId: historyId,
          state: AnswerState.answered,
        ),
      TutorDone(:final answer, :final historyId, :final passages) =>
        message.copyWith(
          text: answer.text,
          source: answer.source,
          passages: passages,
          stopped: answer.stopped,
          historyId: historyId,
          state: AnswerState.answered,
        ),
      TutorOffline(:final passages, :final pendingQuestionId) =>
        message.copyWith(
          text: '',
          passages: passages,
          pendingQuestionId: pendingQuestionId,
          state: AnswerState.offline,
        ),
      TutorDailyLimitReached(:final passages) =>
        message.copyWith(passages: passages, state: AnswerState.limitReached),
      TutorOutOfScope() => message.copyWith(state: AnswerState.outOfScope),
      TutorSubjectUnsupported() =>
        message.copyWith(state: AnswerState.unsupported),
      TutorNeedsInternet() =>
        message.copyWith(text: '', state: AnswerState.needsInternet),
      TutorError() => message.copyWith(text: '', state: AnswerState.failed),
    };
  }
}
