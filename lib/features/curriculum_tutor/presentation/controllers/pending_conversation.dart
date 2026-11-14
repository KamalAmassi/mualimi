import 'dart:async';

import '../../domain/entities/pending_question.dart';
import '../../domain/entities/question_history_item.dart';
import '../../domain/usecases/get_history_item_usecase.dart';
import '../../domain/usecases/get_pending_questions_usecase.dart';
import '../../domain/usecases/observe_answer_taps_usecase.dart';
import '../../domain/usecases/process_pending_questions_usecase.dart';
import '../services/pending_question_sync_service.dart';
import 'chat_transcript.dart';

/// Keeps queued questions and notification taps in step with the transcript.
class PendingConversation {
  PendingConversation({
    required ChatTranscript transcript,
    required PendingQuestionSyncService sync,
    required GetPendingQuestionsUseCase getPending,
    required GetHistoryItemUseCase getHistoryItem,
    required ObserveAnswerTapsUseCase observeTaps,
    required void Function() onOpenAnswer,
  })  : _transcript = transcript,
        _sync = sync,
        _getPending = getPending,
        _getHistoryItem = getHistoryItem,
        _observeTaps = observeTaps,
        _onOpenAnswer = onOpenAnswer;

  final ChatTranscript _transcript;
  final PendingQuestionSyncService _sync;
  final GetPendingQuestionsUseCase _getPending;
  final GetHistoryItemUseCase _getHistoryItem;
  final ObserveAnswerTapsUseCase _observeTaps;
  final void Function() _onOpenAnswer;
  final _subscriptions = <StreamSubscription<Object>>[];

  Future<void> start() async {
    for (final PendingQuestion q in await _getPending()) {
      _transcript.addStored(pending: q);
    }
    _subscriptions
      ..add(_sync.answers.listen(_onSynced))
      ..add(_observeTaps().listen(_onTapped));
    await _sync.syncNow();
  }

  Future<void> _onSynced(SyncedAnswer answer) async {
    final item = await _getHistoryItem(answer.historyId);
    if (item == null) return;
    _transcript.resolvePending(
      pendingQuestionId: answer.pendingQuestionId,
      text: item.answer,
      item: item,
    );
  }

  Future<void> _onTapped(int historyId) async {
    final QuestionHistoryItem? item = await _getHistoryItem(historyId);
    if (item == null) return;
    _transcript.addHistoryItem(item);
    _onOpenAnswer();
  }

  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
  }
}
