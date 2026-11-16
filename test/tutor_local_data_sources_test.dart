import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/question_history_local_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/saved_answers_local_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/tutor_usage_local_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/question_history_item.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/saved_answer.dart';

import 'support/tutor_fakes.dart';

void main() {
  late UserDatabase db;

  setUp(() => db = UserDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('TutorUsageLocalDataSource', () {
    test('counts questions per day', () async {
      var now = DateTime(2026, 11, 14, 23, 59);
      final usage = TutorUsageLocalDataSource(db, clock: () => now);

      expect(await usage.countToday(), 0);
      await usage.increment();
      await usage.increment();
      expect(await usage.countToday(), 2);

      now = DateTime(2026, 11, 15, 0, 1);
      expect(await usage.countToday(), 0);
      await usage.increment();
      expect(await usage.countToday(), 1);

      final days = await db.select(db.tutorUsage).get();
      expect(days.map((d) => d.day),
          unorderedEquals(['2026-11-14', '2026-11-15']));
    });
  });

  group('QuestionHistoryLocalDataSource', () {
    test('stores the answer, source and bank flag, newest first', () async {
      final history = QuestionHistoryLocalDataSource(db);
      final firstId = await history.add(const QuestionHistoryItem(
          question: 'سؤال ١',
          answer: 'جواب ١',
          source: testSource,
          fromBank: true));
      await history
          .add(const QuestionHistoryItem(question: 'سؤال ٢', answer: 'جواب ٢'));

      final recent = await history.recent(limit: 10);
      expect(recent.map((h) => h.question), ['سؤال ٢', 'سؤال ١']);
      final stored = (await history.byId(firstId))!;
      expect(stored.fromBank, isTrue);
      expect(stored.source, testSource);
      expect(recent.first.source, isNull);
    });
  });

  group('SavedAnswersLocalDataSource', () {
    test('keeps the printed page and pdf page for opening the book', () async {
      final saved = SavedAnswersLocalDataSource(db);
      await saved.save(
          const SavedAnswer(question: 'س', answer: 'ج', source: testSource));
      final all = await saved.all();
      expect(all.single.source!.printedPage, '16');
      expect(all.single.source!.pdfPage, 20);
      await saved.delete(all.single.id!);
      expect(await saved.all(), isEmpty);
    });
  });
}
