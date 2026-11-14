import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/content_access.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/passage_search_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/pending_question_local_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/question_history_local_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/tutor_usage_local_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/repositories/passage_repository_impl.dart';
import 'package:mualimi/features/curriculum_tutor/data/repositories/pending_question_repository_impl.dart';
import 'package:mualimi/features/curriculum_tutor/data/repositories/question_history_repository_impl.dart';
import 'package:mualimi/features/curriculum_tutor/data/repositories/tutor_usage_repository_impl.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/pending_question.dart';
import 'package:mualimi/features/curriculum_tutor/domain/services/prompt_builder.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/observe_tutor_connection_usecase.dart';
import 'package:mualimi/features/curriculum_tutor/domain/usecases/process_pending_questions_usecase.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/services/pending_question_sync_service.dart';

import 'support/tutor_fakes.dart';

void main() {
  late ContentDatabase content;
  late UserDatabase user;
  late PendingQuestionRepositoryImpl pending;
  late TutorUsageRepositoryImpl usage;
  late QuestionHistoryRepositoryImpl history;
  late FakeLlm llm;
  late FakeConnection connection;
  late FakeNotifications notifications;
  late PendingQuestionSyncService service;

  setUp(() async {
    content = ContentDatabase(NativeDatabase.memory());
    await DevSeedScienceG9.insert(content);
    user = UserDatabase(NativeDatabase.memory());
    pending =
        PendingQuestionRepositoryImpl(PendingQuestionLocalDataSource(user));
    usage = TutorUsageRepositoryImpl(TutorUsageLocalDataSource(user));
    history =
        QuestionHistoryRepositoryImpl(QuestionHistoryLocalDataSource(user));
    llm = FakeLlm();
    connection = FakeConnection();
    notifications = FakeNotifications();
    service = PendingQuestionSyncService(
      process: ProcessPendingQuestionsUseCase(
        pending: pending,
        passages: PassageRepositoryImpl(
            PassageSearchDataSource(ContentAccess(() => content))),
        llm: llm,
        usage: usage,
        connection: connection,
        history: history,
        notifications: notifications,
        promptBuilder: const PromptBuilder(),
        grade: () => 9,
      ),
      connection: ObserveTutorConnectionUseCase(connection),
    );
  });

  tearDown(() async {
    await content.close();
    await user.close();
  });

  Future<int> enqueue(String question) => pending.enqueue(PendingQuestion(
        question: question,
        subjectId: 'science',
        lessonId: DevSeedScienceG9.lessonId,
        chunkIds: const [1, 2],
      ));

  Future<List<PendingQuestionRow>> rows() =>
      user.select(user.pendingQuestions).get();

  test('answers queued questions oldest first and marks them answered',
      () async {
    final first = await enqueue('السؤال الأول');
    final second = await enqueue('السؤال الثاني');
    final published = <int>[];
    service.answers.listen((a) => published.add(a.pendingQuestionId));

    await service.syncNow();
    await Future<void>.delayed(Duration.zero);

    expect(
        llm.prompts.map((p) => p.userMessage).first, contains('السؤال الأول'));
    expect(
        llm.prompts.map((p) => p.userMessage).last, contains('السؤال الثاني'));
    expect(published, [first, second]);
    expect(
        (await rows())
            .every((r) => r.status == 'answered' && r.answeredAt != null),
        isTrue);
    expect(notifications.shown, ['السؤال الأول', 'السؤال الثاني']);
    final saved = await history.recent(limit: 10);
    expect(saved, hasLength(2));
    expect(saved.first.source!.printedPage, isNotEmpty);
  });

  test('the prompt is built from the stored passages', () async {
    await enqueue('سؤال');
    await service.syncNow();
    expect(llm.prompts.single.userMessage,
        contains('[1] (درس: طرق الشحن الكهربائي · ص 12)'));
    expect(llm.prompts.single.userMessage, contains('[2]'));
  });

  test('stops at the daily limit and leaves the rest pending', () async {
    for (var i = 0; i < Limits.dailyQuestionLimit - 1; i++) {
      await usage.recordQuestion();
    }
    await enqueue('أ');
    await enqueue('ب');
    await service.syncNow();

    final all = await rows();
    expect(all.map((r) => r.status), ['answered', 'pending']);
    expect(llm.prompts, hasLength(1));
    expect(await usage.isDailyLimitReached(), isTrue);
  });

  test('a failure keeps the question pending and counts the attempt', () async {
    llm.reply = const Left(NetworkFailure());
    await enqueue('سؤال');
    await service.syncNow();
    final row = (await rows()).single;
    expect(row.status, 'pending');
    expect(row.attempts, 1);
    expect(notifications.shown, isEmpty);
  });

  test('the question is marked failed after the third failed attempt',
      () async {
    llm.reply = const Left(NetworkFailure());
    await enqueue('سؤال');
    for (var i = 0; i < Limits.maxPendingAttempts; i++) {
      await service.syncNow();
    }
    final row = (await rows()).single;
    expect(row.status, 'failed');
    expect(row.attempts, Limits.maxPendingAttempts);

    await service.syncNow();
    expect(llm.prompts, hasLength(Limits.maxPendingAttempts),
        reason: 'failed rows are not retried');
  });

  test('nothing is sent while offline or without a key', () async {
    await enqueue('سؤال');
    connection.isOnline = false;
    await service.syncNow();
    connection.isOnline = true;
    connection.isConfigured = false;
    await service.syncNow();
    expect(llm.prompts, isEmpty);
    expect((await rows()).single.status, 'pending');
  });

  test('a deleted question is not answered', () async {
    final id = await enqueue('سؤال');
    await pending.delete(id);
    await service.syncNow();
    expect(llm.prompts, isEmpty);
  });
}
