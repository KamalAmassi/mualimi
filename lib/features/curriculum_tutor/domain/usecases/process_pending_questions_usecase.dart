import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/answer_source.dart';
import '../entities/passage.dart';
import '../entities/pending_question.dart';
import '../entities/question_history_item.dart';
import '../entities/tutor_answer.dart';
import '../repositories/answer_notification_repository.dart';
import '../repositories/llm_repository.dart';
import '../repositories/passage_repository.dart';
import '../repositories/pending_question_repository.dart';
import '../repositories/question_history_repository.dart';
import '../repositories/tutor_connection_repository.dart';
import '../repositories/tutor_usage_repository.dart';
import '../services/prompt_builder.dart';
import 'generate_answer_usecase.dart';

class SyncedAnswer extends Equatable {
  const SyncedAnswer({
    required this.pendingQuestionId,
    required this.historyId,
    required this.answer,
  });

  final int pendingQuestionId;
  final int historyId;
  final TutorAnswer answer;

  @override
  List<Object?> get props => [pendingQuestionId, historyId, answer];
}

/// Answers queued questions oldest first, one at a time, with a single
/// non-streaming request each. Stops when the connection drops or the daily
/// limit is reached; the rest wait for the next run.
class ProcessPendingQuestionsUseCase
    implements StreamUseCase<SyncedAnswer, NoParams> {
  ProcessPendingQuestionsUseCase({
    required PendingQuestionRepository pending,
    required PassageRepository passages,
    required LlmRepository llm,
    required TutorUsageRepository usage,
    required TutorConnectionRepository connection,
    required QuestionHistoryRepository history,
    required AnswerNotificationRepository notifications,
    required PromptBuilder promptBuilder,
    required GradeReader grade,
  })  : _pending = pending,
        _passages = passages,
        _llm = llm,
        _usage = usage,
        _connection = connection,
        _history = history,
        _notifications = notifications,
        _promptBuilder = promptBuilder,
        _grade = grade;

  final PendingQuestionRepository _pending;
  final PassageRepository _passages;
  final LlmRepository _llm;
  final TutorUsageRepository _usage;
  final TutorConnectionRepository _connection;
  final QuestionHistoryRepository _history;
  final AnswerNotificationRepository _notifications;
  final PromptBuilder _promptBuilder;
  final GradeReader _grade;

  @override
  Stream<SyncedAnswer> call(NoParams params) async* {
    if (!_connection.isConfigured) return;
    for (final question in await _pending.pendingOldestFirst()) {
      if (!_connection.isOnline || await _usage.isDailyLimitReached()) return;
      final synced = await _answer(question);
      if (synced != null) yield synced;
    }
  }

  Future<SyncedAnswer?> _answer(PendingQuestion question) async {
    final id = question.id!;
    final passages = (await _passages.findByIds(question.chunkIds))
        .getOrElse(() => const <Passage>[]);
    if (passages.isEmpty) {
      await _pending.recordFailedAttempt(id);
      return null;
    }
    final prompt = _promptBuilder.build(
      grade: _grade(),
      question: question.question,
      passages: passages,
    );
    final result = await _llm.answer(prompt);
    final text = result.getOrElse(() => '');
    if (result.isLeft() || text.isEmpty) {
      await _pending.recordFailedAttempt(id);
      return null;
    }

    final answer = TutorAnswer(
        text: text, source: AnswerSource.fromPassage(passages.first));
    await _usage.recordQuestion();
    final historyId = await _history.add(QuestionHistoryItem(
        question: question.question, answer: text, source: answer.source));
    await _pending.markAnswered(id);
    await _notifications.notifyAnswerReady(
        question: question.question, historyId: historyId);
    return SyncedAnswer(
        pendingQuestionId: id, historyId: historyId, answer: answer);
  }
}
