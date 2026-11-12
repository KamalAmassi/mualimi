import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/content_seed.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/core/utils/arabic_normalizer.dart';

void main() {
  late ContentDatabase db;

  setUp(() async {
    db = ContentDatabase(NativeDatabase.memory());
    await ContentSeed.insert(db);
  });

  tearDown(() => db.close());

  test('seed inserts the grade 9 charging lesson', () async {
    final lesson = await db.select(db.lessons).getSingle();
    expect(lesson.title, 'طرق الشحن الكهربائي');
    expect(await db.select(db.chunks).get(), hasLength(3));
  });

  test('FTS5 index finds normalized text', () async {
    final query = ArabicNormalizer.normalize('الإلكترونات');
    final hits = await db.customSelect(
        'SELECT rowid FROM chunks_fts WHERE chunks_fts MATCH ?',
        variables: [Variable.withString('"$query"')]).get();
    expect(hits, hasLength(1));
  });

  test('user database creates', () async {
    final user = UserDatabase(NativeDatabase.memory());
    expect(await user.select(user.savedAnswers).get(), isEmpty);
    await user.close();
  });
}
