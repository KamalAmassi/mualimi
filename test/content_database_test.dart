import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/core/utils/arabic_normalizer.dart';

void main() {
  late ContentDatabase db;

  setUp(() async {
    db = ContentDatabase(NativeDatabase.memory());
    await DevSeedScienceG9.insert(db);
  });

  tearDown(() => db.close());

  test('seed inserts the grade 9 charging lesson with its passages', () async {
    final lessons = await db.select(db.lessons).get();
    expect(lessons.map((l) => l.title), contains(DevSeedScienceG9.lessonTitle));
    final chunks = await db.select(db.chunks).get();
    expect(chunks.where((c) => c.lessonId == DevSeedScienceG9.lessonId).length,
        greaterThanOrEqualTo(10));
    expect(chunks.where((c) => c.lessonId == DevSeedScienceG9.otherLessonId),
        hasLength(4));
    expect(
        chunks.every((c) => c.pdfPage > 0 && c.printedPage.isNotEmpty), isTrue);
  });

  test('seed inserts the question bank and prebuilt answers', () async {
    expect(await db.select(db.questionBank).get(), hasLength(10));
    final kinds =
        (await db.select(db.prebuiltAnswers).get()).map((a) => a.kind);
    expect(kinds, unorderedEquals(['explain', 'summary', 'terms']));
  });

  test('question bank FTS index stays in sync', () async {
    final hits = await db.customSelect(
        'SELECT rowid FROM question_bank_fts WHERE question_bank_fts MATCH ?',
        variables: [Variable.withString('"الكشاف"')]).get();
    expect(hits, hasLength(1));
  });

  test('FTS5 index finds normalized text', () async {
    final query = ArabicNormalizer.normalize('الإلكترونات');
    final hits = await db.customSelect(
        'SELECT rowid FROM chunks_fts WHERE chunks_fts MATCH ?',
        variables: [Variable.withString('"$query"')]).get();
    expect(hits, isNotEmpty);
  });

  test('user database creates', () async {
    final user = UserDatabase(NativeDatabase.memory());
    expect(await user.select(user.savedAnswers).get(), isEmpty);
    expect(await user.select(user.pendingQuestions).get(), isEmpty);
    expect(await user.select(user.tutorUsage).get(), isEmpty);
    await user.close();
  });
}
