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
}
