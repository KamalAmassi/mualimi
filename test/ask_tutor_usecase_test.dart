import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/device_tier.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/answer_source.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/quick_action.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/retrieved_chunk.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/tutor_event.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/llm_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/prebuilt_answer_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/retrieval_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/tutor_scope_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/ask_tutor_params.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/ask_tutor_usecase.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/build_prompt_usecase.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/quick_action_usecase.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/retrieve_chunks_usecase.dart';

class _FakeScope implements TutorScopeRepository {
  _FakeScope(this.enabled);
  final bool enabled;
  @override
  Future<bool> isTutorEnabled(String subjectId, {String? lessonId}) async => enabled;
}

class _FakeRetrieval implements RetrievalRepository {
  List<RetrievedChunk> keyword = const [];
  List<RetrievedChunk> semantic = const [];
  Failure? keywordFailure;
  final queries = <String>[];

  @override
  Future<Either<Failure, List<RetrievedChunk>>> searchKeywords(String q,
      {required String subjectId, String? lessonId, required int limit}) async {
    queries.add(q);
    final f = keywordFailure;
    return f == null ? Right(keyword) : Left(f);
  }

  @override
  Future<Either<Failure, List<RetrievedChunk>>> searchSemantic(String q,
          {required String subjectId, String? lessonId, required int limit}) async =>
      Right(semantic);
}

class _FakeLlm implements LlmRepository {
  List<String> tokens = const ['الشحن ', 'بالدلك'];
  bool fail = false;
  int calls = 0;
  String? prompt;
  int? maxOutputTokens;

  @override
  Stream<String> generate(String prompt, {required int maxOutputTokens}) async* {
    calls++;
    this.prompt = prompt;
    this.maxOutputTokens = maxOutputTokens;
    if (fail) throw const ModelException('not ready');
    for (final t in tokens) {
      yield t;
    }
  }

  @override
  Future<void> stop() async {}
}

class _FakePrebuilt implements PrebuiltAnswerRepository {
  String? answer;
  @override
  Future<String?> find(String lessonId, QuickAction action) async => answer;
}

RetrievedChunk chunk(int id, double score, {int page = 12, String text = 'الشحن بالدلك'}) =>
    RetrievedChunk(id: id, lessonId: 'l1', page: page, text: text, score: score);

void main() {
  late _FakeRetrieval retrieval;
  late _FakeLlm llm;
  var tier = DeviceTier.full;
  var scopeEnabled = true;

  AskTutorUseCase build() => AskTutorUseCase(
        scope: _FakeScope(scopeEnabled),
        retrieve: RetrieveChunksUseCase(retrieval),
        buildPrompt: const BuildPromptUseCase(),
        llm: llm,
        deviceTier: () => tier,
      );

  const params = AskTutorParams(question: 'ما هو الشحن بالدَّلك؟', subjectId: 'science', lessonId: 'l1');

  setUp(() {
    retrieval = _FakeRetrieval();
    llm = _FakeLlm();
    tier = DeviceTier.full;
    scopeEnabled = true;
  });

  test('subjectUnsupported: tutor-disabled subject never searches or generates', () async {
    scopeEnabled = false;
    final events = await build()(params).toList();
    expect(events, [const TutorSubjectUnsupported()]);
    expect(retrieval.queries, isEmpty);
    expect(llm.calls, 0);
  });

  group('outOfScope', () {
    test('top score below the threshold', () async {
      retrieval.keyword = [chunk(1, Limits.outOfScopeThreshold - 0.01)];
      final events = await build()(params).toList();
      expect(events, [const TutorOutOfScope()]);
      expect(llm.calls, 0);
    });

    test('no chunks at all', () async {
      final events = await build()(params).toList();
      expect(events, [const TutorOutOfScope()]);
    });

    test('a score exactly at the threshold is in scope', () async {
      retrieval.keyword = [chunk(1, Limits.outOfScopeThreshold)];
      final events = await build()(params).toList();
      expect(events.last, isA<TutorDone>());
    });
  });

  test('searchOnly: returns the passages and never generates', () async {
    tier = DeviceTier.searchOnly;
    final hit = chunk(1, 0.9);
    retrieval.keyword = [hit];
    final events = await build()(params).toList();
    expect(events, [
      TutorPassages([hit])
    ]);
    expect(llm.calls, 0);
  });

  group('normal generation', () {
    setUp(() => retrieval.keyword = [chunk(7, 0.9, page: 14, text: 'نص المقطع')]);

    test('streams tokens then done with lesson and page', () async {
      final events = await build()(params).toList();
      expect(events, [
        const TutorToken('الشحن '),
        const TutorToken('بالدلك'),
        const TutorDone(AnswerSource(lessonId: 'l1', page: 14)),
      ]);
    });

    test('retrieves with the normalized question', () async {
      await build()(params).toList();
      expect(retrieval.queries.single, 'ما هو الشحن بالدلك؟');
    });

    test('prompt contains the chunk, its page and the original question', () async {
      await build()(params).toList();
      expect(llm.prompt, contains('نص المقطع'));
      expect(llm.prompt, contains('14'));
      expect(llm.prompt, contains(params.question));
    });

    test('caps the reply length', () async {
      await build()(params).toList();
      expect(llm.maxOutputTokens, Limits.maxOutputTokens);
    });

    test('a model failure becomes a TutorError, with no done event', () async {
      llm.fail = true;
      final events = await build()(params).toList();
      expect(events.single, isA<TutorError>());
      expect((events.single as TutorError).failure, isA<ModelFailure>());
    });
  });

  test('a retrieval failure becomes a TutorError', () async {
    retrieval.keywordFailure = const DatabaseFailure('no pack');
    final events = await build()(params).toList();
    expect(events.single, isA<TutorError>());
    expect(llm.calls, 0);
  });

  group('RetrieveChunksUseCase.merge', () {
    test('keyword alone keeps its full score (not halved)', () {
      final merged = RetrieveChunksUseCase.merge([chunk(1, 0.8)], const []);
      expect(merged.single.score, closeTo(0.8, 1e-9));
    });

    test('semantic alone keeps its full score', () {
      final merged = RetrieveChunksUseCase.merge(const [], [chunk(1, 0.6)]);
      expect(merged.single.score, closeTo(0.6, 1e-9));
    });

    test('a chunk found by both is blended by weight and ranked first', () {
      final merged = RetrieveChunksUseCase.merge(
        [chunk(1, 0.5), chunk(2, 0.5)],
        [chunk(1, 1.0)],
      );
      expect(merged.first.id, 1);
      expect(merged.first.score,
          closeTo(Limits.ftsWeight * 0.5 + Limits.vectorWeight * 1.0, 1e-9));
    });

    test('returns at most the configured number of chunks, best first', () {
      final many = [for (var i = 0; i < 10; i++) chunk(i, i / 10)];
      final merged = RetrieveChunksUseCase.merge(many, const []);
      expect(merged, hasLength(Limits.retrievalMaxChunks));
      expect(merged.first.id, 9);
    });

    test('nothing in, nothing out', () {
      expect(RetrieveChunksUseCase.merge(const [], const []), isEmpty);
    });
  });

  group('QuickActionUseCase', () {
    late _FakePrebuilt prebuilt;

    setUp(() {
      prebuilt = _FakePrebuilt();
      retrieval.keyword = [chunk(1, 0.9)];
    });

    const quick = QuickActionParams(action: QuickAction.summary, subjectId: 'science', lessonId: 'l1');

    test('uses the prebuilt answer and does not touch the model', () async {
      prebuilt.answer = 'ملخص جاهز';
      final events = await QuickActionUseCase(prebuilt, build())(quick).toList();
      expect(events.first, const TutorToken('ملخص جاهز'));
      expect(events.last, isA<TutorDone>());
      expect(llm.calls, 0);
      expect(retrieval.queries, isEmpty);
    });

    test('falls back to generating when no prebuilt answer exists', () async {
      final events = await QuickActionUseCase(prebuilt, build())(quick).toList();
      expect(llm.calls, 1);
      expect(events.last, isA<TutorDone>());
    });
  });
}
