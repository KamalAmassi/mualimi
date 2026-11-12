import '../../../../core/constants/limits.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/device_tier.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/arabic_normalizer.dart';
import '../entities/answer_source.dart';
import '../entities/tutor_event.dart';
import '../repositories/llm_repository.dart';
import '../repositories/tutor_scope_repository.dart';
import 'ask_tutor_params.dart';
import 'build_prompt_usecase.dart';
import 'retrieve_chunks_usecase.dart';

typedef DeviceTierReader = DeviceTier Function();

/// The tutor pipeline: gate by subject, normalize, retrieve, gate by score
/// and device, build the prompt, stream the answer.
class AskTutorUseCase implements StreamUseCase<TutorEvent, AskTutorParams> {
  AskTutorUseCase({
    required TutorScopeRepository scope,
    required RetrieveChunksUseCase retrieve,
    required BuildPromptUseCase buildPrompt,
    required LlmRepository llm,
    required DeviceTierReader deviceTier,
  })  : _scope = scope,
        _retrieve = retrieve,
        _buildPrompt = buildPrompt,
        _llm = llm,
        _deviceTier = deviceTier;

  final TutorScopeRepository _scope;
  final RetrieveChunksUseCase _retrieve;
  final BuildPromptUseCase _buildPrompt;
  final LlmRepository _llm;
  final DeviceTierReader _deviceTier;

  @override
  Stream<TutorEvent> call(AskTutorParams params) async* {
    if (!await _scope.isTutorEnabled(params.subjectId, lessonId: params.lessonId)) {
      yield const TutorSubjectUnsupported();
      return;
    }

    final normalized = AskTutorParams(
      question: ArabicNormalizer.normalize(params.question),
      subjectId: params.subjectId,
      lessonId: params.lessonId,
    );
    final retrieved = await _retrieve(normalized);
    final failure = retrieved.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      yield TutorError(failure);
      return;
    }
    final chunks = retrieved.getOrElse(() => const []);

    if (chunks.isEmpty || chunks.first.score < Limits.outOfScopeThreshold) {
      yield const TutorOutOfScope();
      return;
    }
    if (_deviceTier() == DeviceTier.searchOnly) {
      yield TutorPassages(chunks);
      return;
    }

    final prompt = _buildPrompt(params.question, chunks);
    try {
      await for (final token in _llm.generate(prompt, maxOutputTokens: Limits.maxOutputTokens)) {
        yield TutorToken(token);
      }
    } on ModelException catch (e) {
      yield TutorError(ModelFailure(e.message));
      return;
    }
    yield TutorDone(AnswerSource(lessonId: chunks.first.lessonId, page: chunks.first.page));
  }
}
