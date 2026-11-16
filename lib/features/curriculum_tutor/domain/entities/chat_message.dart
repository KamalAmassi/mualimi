import 'package:equatable/equatable.dart';

import 'answer_source.dart';
import 'passage.dart';

enum AnswerState {
  streaming,
  answered,
  outOfScope,
  unsupported,
  offline,
  limitReached,
  needsInternet,
  failed,
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.isUser,
    this.text = '',
    this.question,
    this.state = AnswerState.answered,
    this.source,
    this.passages = const [],
    this.fromBank = false,
    this.stopped = false,
    this.pendingQuestionId,
    this.historyId,
  });

  final int id;
  final bool isUser;
  final String text;

  /// For an answer: the question it answers (needed to save, report or follow up).
  final String? question;
  final AnswerState state;
  final AnswerSource? source;
  final List<Passage> passages;
  final bool fromBank;
  final bool stopped;

  /// Set while the question waits in the offline queue.
  final int? pendingQuestionId;
  final int? historyId;

  bool get isPending =>
      pendingQuestionId != null && state == AnswerState.offline;

  bool get hasAnswerText =>
      !isUser && state == AnswerState.answered && text.isNotEmpty;

  /// Follow-up chips need the passages the answer was written from.
  bool get canFollowUp => hasAnswerText && !fromBank && passages.isNotEmpty;

  ChatMessage copyWith({
    String? text,
    AnswerState? state,
    AnswerSource? source,
    List<Passage>? passages,
    bool? fromBank,
    bool? stopped,
    int? pendingQuestionId,
    int? historyId,
    bool clearPending = false,
  }) =>
      ChatMessage(
        id: id,
        isUser: isUser,
        text: text ?? this.text,
        question: question,
        state: state ?? this.state,
        source: source ?? this.source,
        passages: passages ?? this.passages,
        fromBank: fromBank ?? this.fromBank,
        stopped: stopped ?? this.stopped,
        pendingQuestionId:
            clearPending ? null : pendingQuestionId ?? this.pendingQuestionId,
        historyId: historyId ?? this.historyId,
      );

  @override
  List<Object?> get props => [
        id,
        isUser,
        text,
        question,
        state,
        source,
        passages,
        fromBank,
        stopped,
        pendingQuestionId,
        historyId,
      ];
}
