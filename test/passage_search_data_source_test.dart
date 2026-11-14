import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/utils/arabic_normalizer.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/content_access.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/fts_query_builder.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/passage_search_data_source.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/question_bank_local_data_source.dart';

String normalize(String q) => ArabicNormalizer.normalize(q);

void main() {
  group('FtsQueryBuilder', () {
    test('quotes each meaningful word as a prefix term joined with OR', () {
      expect(FtsQueryBuilder.build(normalize('ما الشحن بالدلك؟')),
          '"الشحن"* OR "بالدلك"*');
    });

    test('FTS syntax in user text cannot leak through', () {
      expect(FtsQueryBuilder.build(normalize('شحن" OR NOT *')),
          '"شحن"* OR "OR"* OR "NOT"*');
    });

    test('nothing searchable gives null', () {
      expect(FtsQueryBuilder.build('؟! ...'), isNull);
      expect(FtsQueryBuilder.build(normalize('ما هو')), isNull);
    });
  });

  group('PassageSearchDataSource (dev seed)', () {
    late ContentDatabase db;
    late PassageSearchDataSource search;

    setUp(() async {
      db = ContentDatabase(NativeDatabase.memory());
      await DevSeedScienceG9.insert(db);
      search = PassageSearchDataSource(ContentAccess(() => db));
    });

    tearDown(() => db.close());

    test(
        'finds the passage that answers the question, with its pages and titles',
        () async {
      final hits = await search.search(normalize('كيف نشحن كرة فلزية بالحث؟'),
          subjectId: DevSeedScienceG9.subjectId);
      expect(hits, isNotEmpty);
      expect(hits.first.printedPage, '18');
      expect(hits.first.pdfPage, 22);
      expect(hits.first.lessonTitle, DevSeedScienceG9.lessonTitle);
      expect(hits.first.subjectName, DevSeedScienceG9.subjectName);
      expect(hits.first.score, inInclusiveRange(0.0, 1.0));
    });

    test('returns at most the top four passages, best first', () async {
      final hits = await search.search(normalize('الشحنة الإلكترونات الشحن'),
          subjectId: DevSeedScienceG9.subjectId);
      expect(hits.length, lessThanOrEqualTo(4));
      final scores = hits.map((h) => h.score).toList();
      expect([...scores]..sort((a, b) => b.compareTo(a)), scores);
    });

    test('a lesson filter keeps results inside that lesson', () async {
      final hits = await search.search(normalize('قانون كولوم'),
          subjectId: DevSeedScienceG9.subjectId,
          lessonId: DevSeedScienceG9.otherLessonId);
      expect(hits, isNotEmpty);
      expect(hits.every((h) => h.lessonId == DevSeedScienceG9.otherLessonId),
          isTrue);
    });

    test('falls back to the whole subject when the lesson has no match',
        () async {
      final hits = await search.search(normalize('مانعة الصواعق'),
          subjectId: DevSeedScienceG9.subjectId,
          lessonId: DevSeedScienceG9.otherLessonId);
      expect(hits, isNotEmpty);
      expect(hits.first.lessonId, DevSeedScienceG9.lessonId);
    });

    test('another subject sees nothing', () async {
      final hits =
          await search.search(normalize('الشحن بالحث'), subjectId: 'math');
      expect(hits, isEmpty);
    });

    test('an off-topic question finds nothing', () async {
      final hits = await search.search(normalize('من اخترع البطارية'),
          subjectId: DevSeedScienceG9.subjectId);
      expect(hits, isEmpty);
    });

    test('findByIds keeps the requested order and skips unknown ids', () async {
      final hits = await search.findByIds([3, 999, 1]);
      expect(hits.map((h) => h.id), [3, 1]);
    });

    test('lessonPassages follows book order and respects the character cap',
        () async {
      final all = await search.lessonPassages(DevSeedScienceG9.lessonId,
          maxChars: 1 << 20);
      expect(all.map((p) => int.parse(p.printedPage)),
          orderedEquals([for (var i = 12; i <= 23; i++) i]));
      final capped = await search.lessonPassages(DevSeedScienceG9.lessonId,
          maxChars: 1500);
      expect(capped, isNotEmpty);
      expect(capped.length, lessThan(all.length));
      expect(capped.fold<int>(0, (n, p) => n + p.text.length),
          lessThanOrEqualTo(1500));
    });
  });

  group('QuestionBankLocalDataSource (dev seed)', () {
    late ContentDatabase db;
    late QuestionBankLocalDataSource bank;

    setUp(() async {
      db = ContentDatabase(NativeDatabase.memory());
      await DevSeedScienceG9.insert(db);
      bank = QuestionBankLocalDataSource(ContentAccess(() => db));
    });

    tearDown(() => db.close());

    test('candidates carry the source with pages', () async {
      final hits = await bank.candidates(
          normalize('ما وظيفة الكشاف الكهربائي؟'),
          subjectId: DevSeedScienceG9.subjectId);
      expect(hits.first.source.printedPage, '17');
      expect(hits.first.source.pdfPage, 21);
      expect(hits.first.source.lessonTitle, DevSeedScienceG9.lessonTitle);
    });

    test('example questions prefer the lesson and fall back to the subject',
        () async {
      final inLesson = await bank.exampleQuestions(DevSeedScienceG9.subjectId,
          lessonId: DevSeedScienceG9.lessonId, limit: 3);
      expect(inLesson, hasLength(3));
      final fallback = await bank.exampleQuestions(DevSeedScienceG9.subjectId,
          lessonId: DevSeedScienceG9.otherLessonId, limit: 3);
      expect(fallback, hasLength(3));
      expect(await bank.exampleQuestions('math', limit: 3), isEmpty);
    });
  });
}
