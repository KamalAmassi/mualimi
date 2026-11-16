import 'package:dartz/dartz.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/answer_source.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/bank_entry.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/bank_match.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/llm_prompt.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/passage.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/pending_question.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/question_history_item.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/answer_notification_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/llm_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/passage_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/pending_question_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/question_bank_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/question_history_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/tutor_connection_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/tutor_scope_repository.dart';
import 'package:mualimi/features/curriculum_tutor/domain/repositories/tutor_usage_repository.dart';

const testSource = AnswerSource(
  subjectId: 'science',
  subjectName: 'العلوم والحياة',
  lessonId: 'science-9-charging',
  lessonTitle: 'طرق الشحن الكهربائي',
  printedPage: '16',
  pdfPage: 20,
);

Passage passage({int id = 1, double score = 0.8, String text = 'نص المقطع'}) =>
    Passage(
      id: id,
      subjectId: testSource.subjectId,
      subjectName: testSource.subjectName,
      lessonId: testSource.lessonId,
      lessonTitle: testSource.lessonTitle,
      printedPage: testSource.printedPage,
      pdfPage: testSource.pdfPage,
      text: text,
      score: score,
    );

class FakeScope implements TutorScopeRepository {
  FakeScope({this.enabled = true});
  bool enabled;

  @override
  Future<bool> isTutorEnabled(String subjectId, {String? lessonId}) async =>
      enabled;
}

class FakeBank implements QuestionBankRepository {
  BankMatch? match;

  @override
  Future<Either<Failure, BankMatch?>> findMatch(String normalizedQuestion,
          {required String subjectId}) async =>
      Right(match);

  @override
  Future<List<String>> exampleQuestions(String subjectId,
          {String? lessonId, int limit = 3}) async =>
      const [];
}

BankMatch bankMatch() => const BankMatch(
      BankEntry(
        id: 1,
        questionNormalized: 'سؤال',
        answer: 'جواب من الرزمة',
        source: testSource,
      ),
      0.9,
    );

class FakePassages implements PassageRepository {
  List<Passage> found = const [];
  List<Passage> byId = const [];
  List<Passage> lesson = const [];

  @override
  Future<Either<Failure, List<Passage>>> search(String normalizedQuestion,
          {required String subjectId, String? lessonId}) async =>
      Right(found);

  @override
  Future<Either<Failure, List<Passage>>> findByIds(List<int> ids) async =>
      Right(byId);

  @override
  Future<Either<Failure, List<Passage>>> lessonPassages(String lessonId,
          {required int maxChars}) async =>
      Right(lesson);
}

class FakeHistory implements QuestionHistoryRepository {
  final items = <QuestionHistoryItem>[];

  @override
  Future<int> add(QuestionHistoryItem item) async {
    items.add(item);
    return items.length;
  }

  @override
  Future<QuestionHistoryItem?> byId(int id) async => items[id - 1];

  @override
  Future<List<QuestionHistoryItem>> recent({required int limit}) async => items;

  @override
  Future<void> clear() async => items.clear();
}

class FakeConnection implements TutorConnectionRepository {
  FakeConnection({this.isOnline = true, this.isConfigured = true});

  @override
  bool isOnline;

  @override
  bool isConfigured;

  @override
  Stream<bool> get onlineChanges => const Stream.empty();
}

class FakeUsage implements TutorUsageRepository {
  FakeUsage({this.limitReached = false});
  bool limitReached;
  int recorded = 0;

  @override
  Future<bool> isDailyLimitReached() async => limitReached;

  @override
  Future<void> recordQuestion() async {
    recorded++;
    if (recorded >= limitAfter) limitReached = true;
  }

  /// The limit becomes reached after this many recorded questions.
  int limitAfter = 1 << 30;
}

class FakePending implements PendingQuestionRepository {
  final queued = <PendingQuestion>[];

  @override
  Future<int> enqueue(PendingQuestion question) async {
    queued.add(question);
    return queued.length;
  }

  @override
  Future<List<PendingQuestion>> pendingOldestFirst() async => queued;

  @override
  Future<void> markAnswered(int id) async {}

  @override
  Future<void> recordFailedAttempt(int id) async {}

  @override
  Future<void> delete(int id) async {}
}

/// Streams [chunks]; with [failAfter] set the stream emits a failure after that many chunks.
class FakeLlm implements LlmRepository {
  FakeLlm({this.chunks = const ['جواب ', 'قصير'], this.failAfter});

  List<String> chunks;
  int? failAfter;
  Either<Failure, String> reply = const Right('جواب كامل');
  final prompts = <LlmPrompt>[];
  bool stopped = false;

  @override
  bool get wasStopped => stopped;

  @override
  Stream<Either<Failure, String>> streamAnswer(LlmPrompt prompt) async* {
    prompts.add(prompt);
    for (var i = 0; i < chunks.length; i++) {
      if (failAfter == i) {
        yield const Left(NetworkFailure());
        return;
      }
      yield Right(chunks[i]);
    }
    if (failAfter != null && failAfter! >= chunks.length) {
      yield const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> answer(LlmPrompt prompt) async {
    prompts.add(prompt);
    return reply;
  }

  @override
  Future<void> stop() async => stopped = true;
}

class FakeNotifications implements AnswerNotificationRepository {
  final shown = <String>[];

  @override
  Future<void> notifyAnswerReady(
          {required String question, required int historyId}) async =>
      shown.add(question);

  @override
  Future<void> requestPermission() async {}

  @override
  Stream<int> get taps => const Stream.empty();
}

abstract final class FakeHistoryItem {
  static const item = QuestionHistoryItem(
      id: 9, question: 'سؤال', answer: 'وصل الجواب', source: testSource);
}
