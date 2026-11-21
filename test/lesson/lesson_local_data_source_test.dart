import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/services/app_paths_service.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/features/lesson/data/datasources/lesson_local_data_source.dart';

class _InMemoryDatabaseService extends DatabaseService {
  _InMemoryDatabaseService(this._db) : super(AppPathsService());
  final ContentDatabase _db;

  @override
  ContentDatabase get content => _db;
}

void main() {
  late ContentDatabase db;

  setUp(() => db = ContentDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('key terms come back in id order, only for the lesson', () async {
    for (final (id, lessonId, term) in [
      (3, 'l1', 'third'),
      (1, 'l1', 'first'),
      (4, 'l2', 'other'),
      (2, 'l1', 'second'),
    ]) {
      await db.into(db.keyTerms).insert(KeyTermsCompanion.insert(
            id: Value(id),
            lessonId: lessonId,
            term: term,
            definition: '$term definition',
          ));
    }
    final terms = await LessonLocalDataSource(_InMemoryDatabaseService(db)).keyTerms('l1');
    expect(terms.map((t) => t.term), ['first', 'second', 'third']);
  });

  test('a lesson carries its subject name and unit title', () async {
    await db.into(db.subjects).insert(SubjectsCompanion.insert(id: 's1', name: 'Science'));
    await db.into(db.units).insert(UnitsCompanion.insert(id: 'u1', subjectId: 's1', title: 'Unit 2'));
    await db.into(db.lessons).insert(LessonsCompanion.insert(
          id: 'l1',
          unitId: 'u1',
          subjectId: 's1',
          title: 'Charging',
          bookPagesFrom: const Value(44),
          bookPagesTo: const Value(49),
        ));
    final lesson = await LessonLocalDataSource(_InMemoryDatabaseService(db)).lesson('l1');
    expect(lesson.subjectName, 'Science');
    expect(lesson.unitTitle, 'Unit 2');
    expect((lesson.bookPagesFrom, lesson.bookPagesTo), (44, 49));
  });

  test('a lesson without its unit or subject row still loads', () async {
    await db.into(db.lessons).insert(
        LessonsCompanion.insert(id: 'l1', unitId: 'u9', subjectId: 's9', title: 'Charging'));
    final lesson = await LessonLocalDataSource(_InMemoryDatabaseService(db)).lesson('l1');
    expect(lesson.subjectName, isNull);
    expect(lesson.unitTitle, isNull);
  });
}
