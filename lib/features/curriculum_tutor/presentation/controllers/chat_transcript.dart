import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/token_batcher.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/tutor_event.dart';

/// The visible conversation. Applies pipeline events to the answer being
/// streamed, batching tokens so the UI updates about every 50 ms.
class ChatTranscript {
  final messages = <ChatMessage>[].obs;
  int _nextId = 0;
  TokenBatcher? _batcher;

  /// Adds the student's message and an empty answer; returns the answer's id.
  int startExchange(String userText, {required String question}) {
    messages.add(ChatMessage(id: _nextId++, text: userText, isUser: true));
    final answerId = _nextId++;
    messages.add(ChatMessage(id: answerId, text: '', isUser: false, question: question));
    _batcher = TokenBatcher((batch) => _update(answerId, (m) => m.copyWith(text: m.text + batch)));
    return answerId;
  }

  void apply(int id, TutorEvent event) {
    switch (event) {
      case TutorToken(:final text):
        _batcher?.add(text);
      case TutorPassages(:final chunks):
        _update(id, (m) => m.copyWith(passages: chunks));
      case TutorOutOfScope():
        _update(id, (m) => m.copyWith(text: AppStrings.outOfScope));
      case TutorSubjectUnsupported():
        _update(id, (m) => m.copyWith(text: AppStrings.mathSoon));
      case TutorDone(:final source):
        _batcher?.flush();
        _update(id, (m) => m.copyWith(source: source));
      case TutorError():
        fail(id);
    }
  }

  void fail(int id) => _update(id, (m) => m.copyWith(text: AppStrings.answerFailed));

  /// Emits pending tokens and releases the batcher.
  void finish() {
    _batcher?.flush();
    _batcher?.dispose();
    _batcher = null;
  }

  void clear() => messages.clear();

  void dispose() => _batcher?.dispose();

  void _update(int id, ChatMessage Function(ChatMessage) change) {
    final i = messages.indexWhere((m) => m.id == id);
    if (i != -1) messages[i] = change(messages[i]);
  }
}
