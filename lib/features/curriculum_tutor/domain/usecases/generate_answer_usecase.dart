import '../../../../core/constants/limits.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/answer_source.dart';
import '../entities/pending_question.dart';
import '../entities/question_history_item.dart';
import '../entities/tutor_answer.dart';
import '../entities/tutor_event.dart';
import '../repositories/llm_repository.dart';
import '../repositories/pending_question_repository.dart';
import '../repositories/question_history_repository.dart';
import '../repositories/tutor_connection_repository.dart';
import '../repositories/tutor_usage_repository.dart';
import '../services/prompt_builder.dart';
import 'generate_answer_params.dart';

typedef GradeReader = int? Function();

/// Sends a question and its passages to the cloud tutor: connectivity and
/// quota checks, streaming, persistence, and queueing when the cloud is
/// unreachable.
class GenerateAnswerUseCase
    implements StreamUseCase<TutorEvent, GenerateAnswerParams> {
  GenerateAnswerUseCase({
    required TutorConnectionRepository connection,
    required TutorUsageRepository usage,
    required LlmRepository llm,
    required PendingQuestionRepository pending,
    required QuestionHistoryRepository history,
    required PromptBuilder promptBuilder,
    required GradeReader grade,
  })  : _connection = connection,
        _usage = usage,
        _llm = llm,
        _pending = pending,
        _history = history,
        _promptBuilder = promptBuilder,
        _grade = grade;

  final TutorConnectionRepository _connection;
  final TutorUsageRepository _usage;
  final LlmRepository _llm;
  final PendingQuestionRepository _pending;
  final QuestionHistoryRepository _history;
  final PromptBuilder _promptBuilder;
  final GradeReader _grade;

  @override
  Stream<TutorEvent> call(GenerateAnswerParams params) async* {
    final passages = params.passages;
    final shown = passages.take(Limits.maxPassages).toList();
    if (!_connection.isOnline || !_connection.isConfigured) {
      yield await _unreachable(params);
      return;
    }
    if (await _usage.isDailyLimitReached()) {
      yield TutorDailyLimitReached(shown);
      return;
    }

    final prompt = _promptBuilder.build(
      grade: _grade(),
      question: params.question,
      passages: passages,
      previousAnswer: params.previousAnswer,
      followUpInstruction: params.followUpInstruction,
    );
    final text = StringBuffer();
    await for (final chunk in _llm.streamAnswer(prompt)) {
      final failed = chunk.fold<Failure?>((f) => f, (_) => null);
      if (failed != null) {
        yield await _unreachable(params);
        return;
      }
      final piece = chunk.getOrElse(() => '');
      text.write(piece);
      yield TutorToken(piece);
    }

    final answer = TutorAnswer(
      text: text.toString(),
      source: AnswerSource.fromPassage(passages.first),
      stopped: _llm.wasStopped,
    );
    await _usage.recordQuestion();
    final historyId = params.recordHistory
        ? await _history.add(QuestionHistoryItem(
            question: params.question,
            answer: answer.text,
            source: answer.source))
        : null;
    yield TutorDone(answer, historyId: historyId, passages: shown);
  }

  Future<TutorEvent> _unreachable(GenerateAnswerParams params) async {
    if (!params.queueWhenOffline) return const TutorNeedsInternet();
    final id = await _pending.enqueue(PendingQuestion(
      question: params.question,
      subjectId: params.subjectId,
      lessonId: params.lessonId,
      chunkIds: [for (final p in params.passages) p.id],
    ));
    return TutorOffline(params.passages.take(Limits.maxPassages).toList(),
        pendingQuestionId: id);
  }
}
