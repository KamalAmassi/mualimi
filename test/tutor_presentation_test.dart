import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/chat_message.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/pending_question.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/tutor_answer.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/tutor_event.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/controllers/chat_transcript.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/formatting/answer_text_parser.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/formatting/day_label.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/formatting/example_questions.dart';

import 'support/tutor_fakes.dart';

void main() {
  group('AnswerTextParser', () {
    test('splits numbered points and reads bold markers', () {
      final blocks = AnswerTextParser.parse(
          'الفرق هو **الملامسة**:\n1. **بالتوصيل:** يلمس\n٢) بالحث');
      expect(blocks, hasLength(3));
      expect(blocks[0].number, isNull);
      expect(blocks[0].runs.map((r) => r.bold), [false, true, false]);
      expect(blocks[1].number, '1');
      expect(blocks[1].runs.first.bold, isTrue);
      expect(blocks[2].number, '٢');
    });

    test('blank lines are skipped', () {
      expect(AnswerTextParser.parse('أ\n\n\nب'), hasLength(2));
    });
  });

  group('DayLabel', () {
    final now = DateTime(2026, 11, 14, 10);

    test('today, yesterday and older days', () {
      expect(
          DayLabel.of(DateTime(2026, 11, 14, 1), now: now), AppStrings.today);
      expect(DayLabel.of(DateTime(2026, 11, 13, 23), now: now),
          AppStrings.yesterday);
      expect(DayLabel.of(DateTime(2026, 11, 11), now: now), 'قبل 3 أيام');
    });
  });

  group('ExampleQuestions', () {
    test('stored questions come first and templates fill up to three', () {
      final examples = ExampleQuestions.fill(['سؤال من الرزمة'],
          subjectName: 'العلوم', lessonTitle: 'الحث');
      expect(examples, hasLength(3));
      expect(examples.first, 'سؤال من الرزمة');
      expect(examples[1], 'اشرحلي درس الحث');
    });

    test('with no lesson the templates use the subject', () {
      final examples = ExampleQuestions.fill(const [], subjectName: 'العلوم');
      expect(examples, hasLength(3));
      expect(examples.every((e) => e.contains('العلوم')), isTrue);
    });

    test('more stored questions than needed are cut to three', () {
      expect(
        ExampleQuestions.fill(['أ', 'ب', 'ج', 'د'], subjectName: 'ع'),
        ['أ', 'ب', 'ج'],
      );
    });
  });

  group('ChatTranscript', () {
    late ChatTranscript transcript;

    setUp(() => transcript = ChatTranscript());
    tearDown(() => transcript.dispose());

    test(
        'a finished answer replaces streamed text and carries source and passages',
        () {
      final id = transcript.startExchange('سؤال', question: 'سؤال');
      transcript.apply(
        id,
        TutorDone(const TutorAnswer(text: 'جواب', source: testSource),
            historyId: 4, passages: [passage()]),
      );
      final answer = transcript.messages.last;
      expect(answer.state, AnswerState.answered);
      expect(answer.text, 'جواب');
      expect(answer.historyId, 4);
      expect(answer.canFollowUp, isTrue);
    });

    test('a bank answer cannot be followed up and is marked as from the pack',
        () {
      final id = transcript.startExchange('سؤال', question: 'سؤال');
      transcript.apply(
          id,
          const TutorBankAnswer(
              TutorAnswer(text: 'من الرزمة', fromBank: true)));
      expect(transcript.messages.last.fromBank, isTrue);
      expect(transcript.messages.last.canFollowUp, isFalse);
    });

    test(
        'going offline mid-stream drops the partial text and shows the pending badge',
        () {
      final id = transcript.startExchange('سؤال', question: 'سؤال');
      transcript.apply(id, TutorOffline([passage()], pendingQuestionId: 7));
      final answer = transcript.messages.last;
      expect(answer.text, isEmpty);
      expect(answer.isPending, isTrue);
      expect(answer.passages, hasLength(1));
    });

    test('a queued answer arriving later fills the waiting message', () {
      transcript.addStored(
          pending: const PendingQuestion(
              id: 3, question: 'سؤال', subjectId: 's', chunkIds: [1]));
      expect(transcript.messages.last.isPending, isTrue);

      transcript.resolvePending(
        pendingQuestionId: 3,
        text: 'وصل الجواب',
        item: FakeHistoryItem.item,
      );
      final answer = transcript.messages.last;
      expect(answer.isPending, isFalse);
      expect(answer.text, 'وصل الجواب');
      expect(answer.state, AnswerState.answered);
    });

    test('deleting a pending question removes the exchange', () {
      transcript.addStored(
          pending: const PendingQuestion(
              id: 3, question: 'سؤال', subjectId: 's', chunkIds: [1]));
      transcript.removePending(3);
      expect(transcript.messages, isEmpty);
    });

    test('each terminal event maps to its own state', () {
      final cases = <TutorEvent, AnswerState>{
        const TutorOutOfScope(): AnswerState.outOfScope,
        const TutorSubjectUnsupported(): AnswerState.unsupported,
        const TutorNeedsInternet(): AnswerState.needsInternet,
        TutorDailyLimitReached([passage()]): AnswerState.limitReached,
      };
      cases.forEach((event, state) {
        final id = transcript.startExchange('س', question: 'س');
        transcript.apply(id, event);
        expect(transcript.messages.last.state, state);
      });
    });
  });
}
