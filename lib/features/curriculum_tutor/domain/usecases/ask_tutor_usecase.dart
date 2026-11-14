import '../../../../core/constants/limits.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/arabic_normalizer.dart';
import '../entities/passage.dart';
import '../entities/question_history_item.dart';
import '../entities/tutor_answer.dart';
import '../entities/tutor_event.dart';
import '../repositories/passage_repository.dart';
import '../repositories/question_bank_repository.dart';
import '../repositories/question_history_repository.dart';
import '../repositories/tutor_scope_repository.dart';
import 'ask_tutor_params.dart';
import 'generate_answer_params.dart';
import 'generate_answer_usecase.dart';

/// The tutor pipeline for a typed question: subject check, question bank,
/// pack search, scope check, then the cloud tutor.
class AskTutorUseCase implements StreamUseCase<TutorEvent, AskTutorParams> {
  AskTutorUseCase({
    required TutorScopeRepository scope,
    required QuestionBankRepository bank,
    required PassageRepository passages,
    required QuestionHistoryRepository history,
    required GenerateAnswerUseCase generate,
  })  : _scope = scope,
        _bank = bank,
        _passages = passages,
        _history = history,
        _generate = generate;

  final TutorScopeRepository _scope;
  final QuestionBankRepository _bank;
  final PassageRepository _passages;
  final QuestionHistoryRepository _history;
  final GenerateAnswerUseCase _generate;

  @override
  Stream<TutorEvent> call(AskTutorParams params) async* {
    if (!await _scope.isTutorEnabled(params.subjectId,
        lessonId: params.lessonId)) {
      yield const TutorSubjectUnsupported();
      return;
    }

    final normalized = ArabicNormalizer.normalize(params.question);
    final bankResult =
        await _bank.findMatch(normalized, subjectId: params.subjectId);
    final bankFailure = bankResult.fold<Failure?>((f) => f, (_) => null);
    if (bankFailure != null) {
      yield TutorError(bankFailure);
      return;
    }
    final match = bankResult.getOrElse(() => null);
    if (match != null) {
      final answer = TutorAnswer(
        text: match.entry.answer,
        source: match.entry.source,
        fromBank: true,
      );
      final id = await _history.add(QuestionHistoryItem(
        question: params.question,
        answer: answer.text,
        source: answer.source,
        fromBank: true,
      ));
      yield TutorBankAnswer(answer, historyId: id);
      return;
    }

    final found = await _passages.search(normalized,
        subjectId: params.subjectId, lessonId: params.lessonId);
    final searchFailure = found.fold<Failure?>((f) => f, (_) => null);
    if (searchFailure != null) {
      yield TutorError(searchFailure);
      return;
    }
    final passages = found.getOrElse(() => const <Passage>[]);
    if (passages.isEmpty ||
        passages.first.score < Limits.passageScoreThreshold) {
      yield const TutorOutOfScope();
      return;
    }

    yield* _generate(GenerateAnswerParams(
      question: params.question,
      subjectId: params.subjectId,
      lessonId: params.lessonId,
      passages: passages,
    ));
  }
}
