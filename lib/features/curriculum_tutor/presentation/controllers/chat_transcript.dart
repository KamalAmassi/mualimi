import 'package:get/get.dart';

import '../../../../core/utils/token_batcher.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/pending_question.dart';
import '../../domain/entities/question_history_item.dart';
import '../../domain/entities/tutor_event.dart';
import 'tutor_event_applier.dart';

/// The visible conversation. Applies pipeline events to the answer being
/// streamed, batching tokens so the UI updates about every 50 ms.
class ChatTranscript {
  final messages = <ChatMessage>[].obs;
  int _nextId = 0;
  TokenBatcher? _batcher;

  /// Adds the student's message and an empty answer; returns the answer's id.
  int startExchange(String userText, {required String question}) {
    messages.add(ChatMessage(id: _nextId++, isUser: true, text: userText));
    final answerId = _nextId++;
    messages.add(ChatMessage(
      id: answerId,
      isUser: false,
      question: question,
      state: AnswerState.streaming,
    ));
    _batcher = TokenBatcher(
        (batch) => _update(answerId, (m) => m.copyWith(text: m.text + batch)));
    return answerId;
  }

  /// Shows a stored exchange, used for restored queue entries and tapped notifications.
  void addStored({required PendingQuestion pending}) {
    final answerId = _addExchange(pending.question);
    _update(
      answerId,
      (m) =>
          m.copyWith(state: AnswerState.offline, pendingQuestionId: pending.id),
    );
  }

  void addHistoryItem(QuestionHistoryItem item) {
    final shown =
        messages.indexWhere((m) => !m.isUser && m.historyId == item.id);
    if (shown > 0) messages.removeRange(shown - 1, shown + 1);
    final answerId = _addExchange(item.question);
    _update(
      answerId,
      (m) => m.copyWith(
        text: item.answer,
        source: item.source,
        fromBank: item.fromBank,
        historyId: item.id,
      ),
    );
  }

  void apply(int id, TutorEvent event) {
    if (event is TutorToken) {
      _batcher?.add(event.text);
      return;
    }
    if (event is TutorDone) {
      _batcher?.flush();
    } else if (event is TutorOffline ||
        event is TutorNeedsInternet ||
        event is TutorError) {
      _resetStream();
    }
    _update(id, (m) => TutorEventApplier.apply(m, event));
  }

  /// A queued question was answered while the app was open.
  void resolvePending({
    required int pendingQuestionId,
    required String text,
    required QuestionHistoryItem item,
  }) {
    final i =
        messages.indexWhere((m) => m.pendingQuestionId == pendingQuestionId);
    if (i == -1) return;
    messages[i] = messages[i].copyWith(
      text: text,
      source: item.source,
      historyId: item.id,
      state: AnswerState.answered,
      clearPending: true,
    );
  }

  void removePending(int pendingQuestionId) {
    final i =
        messages.indexWhere((m) => m.pendingQuestionId == pendingQuestionId);
    if (i == -1) return;
    messages.removeRange(i > 0 ? i - 1 : i, i + 1);
  }

  void fail(int id) {
    _resetStream();
    _update(id, (m) => m.copyWith(text: '', state: AnswerState.failed));
  }

  /// Emits pending tokens and releases the batcher.
  void finish() {
    _batcher?.flush();
    _batcher?.dispose();
    _batcher = null;
  }

  void clear() => messages.clear();

  void dispose() => _batcher?.dispose();

  int _addExchange(String question) {
    messages.add(ChatMessage(id: _nextId++, isUser: true, text: question));
    final answerId = _nextId++;
    messages.add(ChatMessage(id: answerId, isUser: false, question: question));
    return answerId;
  }

  void _resetStream() {
    _batcher?.dispose();
    _batcher = null;
  }

  void _update(int id, ChatMessage Function(ChatMessage) change) {
    final i = messages.indexWhere((m) => m.id == id);
    if (i != -1) messages[i] = change(messages[i]);
  }
}
