import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/tutor_event.dart';
import 'package:mualimi/features/curriculum_tutor/domain/services/prompt_builder.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/ask_tutor_params.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/ask_tutor_usecase.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/generate_answer_usecase.dart';

import 'support/tutor_fakes.dart';

void main() {
  late FakeScope scope;
  late FakeBank bank;
  late FakePassages passages;
  late FakeHistory history;
  late FakeConnection connection;
  late FakeUsage usage;
  late FakeLlm llm;
  late FakePending pending;
  late AskTutorUseCase ask;

  const params = AskTutorParams(
    question: 'ما هو الشحن بالحث؟',
    subjectId: 'science',
    lessonId: 'science-9-charging',
  );

  setUp(() {
    scope = FakeScope();
    bank = FakeBank();
    passages = FakePassages()
      ..found = [passage(id: 1), passage(id: 2, score: 0.5)];
    history = FakeHistory();
    connection = FakeConnection();
    usage = FakeUsage();
    llm = FakeLlm();
    pending = FakePending();
    ask = AskTutorUseCase(
      scope: scope,
      bank: bank,
      passages: passages,
      history: history,
      generate: GenerateAnswerUseCase(
        connection: connection,
        usage: usage,
        llm: llm,
        pending: pending,
        history: history,
        promptBuilder: const PromptBuilder(),
        grade: () => 9,
      ),
    );
  });

  Future<List<TutorEvent>> run() => ask(params).toList();

  test('unsupported subject stops before any search', () async {
    scope.enabled = false;
    expect(await run(), [const TutorSubjectUnsupported()]);
    expect(llm.prompts, isEmpty);
  });

  test('a question bank hit answers offline from the pack and skips the cloud',
      () async {
    bank.match = bankMatch();
    final events = await run();
    expect(events, hasLength(1));
    final answer = (events.single as TutorBankAnswer).answer;
    expect(answer.fromBank, isTrue);
    expect(answer.text, 'جواب من الرزمة');
    expect(llm.prompts, isEmpty);
    expect(history.items.single.fromBank, isTrue);
    expect(usage.recorded, 0);
  });

  test('no passages is out of scope', () async {
    passages.found = const [];
    expect(await run(), [const TutorOutOfScope()]);
  });

  test('a weak best passage is out of scope', () async {
    passages.found = [passage(score: Limits.passageScoreThreshold - 0.01)];
    expect(await run(), [const TutorOutOfScope()]);
    expect(llm.prompts, isEmpty);
  });

  test('offline queues the question with its passages', () async {
    connection.isOnline = false;
    final events = await run();
    final offline = events.single as TutorOffline;
    expect(offline.pendingQuestionId, 1);
    expect(offline.passages, hasLength(2));
    expect(pending.queued.single.chunkIds, [1, 2]);
    expect(pending.queued.single.question, params.question);
    expect(llm.prompts, isEmpty);
  });

  test('a missing API key queues the question like being offline', () async {
    connection.isConfigured = false;
    final events = await run();
    expect(events.single, isA<TutorOffline>());
    expect(pending.queued, hasLength(1));
  });

  test('the daily limit shows the passages without calling the cloud',
      () async {
    usage.limitReached = true;
    final events = await run();
    expect((events.single as TutorDailyLimitReached).passages, hasLength(2));
    expect(llm.prompts, isEmpty);
    expect(pending.queued, isEmpty);
  });

  test(
      'a successful stream emits tokens, then done with the top passage as source',
      () async {
    final events = await run();
    expect(
        events.whereType<TutorToken>().map((e) => e.text), ['جواب ', 'قصير']);
    final done = events.last as TutorDone;
    expect(done.answer.text, 'جواب قصير');
    expect(done.answer.source!.printedPage, '16');
    expect(done.answer.source!.lessonTitle, 'طرق الشحن الكهربائي');
    expect(done.answer.fromBank, isFalse);
    expect(usage.recorded, 1);
    expect(history.items.single.answer, 'جواب قصير');
    expect(llm.prompts.single.userMessage,
        contains('سؤال الطالب:\n${params.question}'));
  });

  test('a stopped answer is kept and marked as stopped', () async {
    llm.stopped = true;
    final done = (await run()).last as TutorDone;
    expect(done.answer.stopped, isTrue);
    expect(done.answer.text, isNotEmpty);
  });

  test('a failure mid-stream queues the question and returns the passages',
      () async {
    llm.failAfter = 1;
    final events = await run();
    expect(events.first, isA<TutorToken>());
    final offline = events.last as TutorOffline;
    expect(offline.pendingQuestionId, 1);
    expect(pending.queued, hasLength(1));
    expect(usage.recorded, 0);
    expect(history.items, isEmpty);
  });
}
