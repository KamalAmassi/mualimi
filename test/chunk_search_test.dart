import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/content_seed.dart';
import 'package:mualimi/core/services/app_paths_service.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/core/utils/arabic_normalizer.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/fts_query_builder.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/sqlite_chunk_search_data_source.dart';

class _Databases extends DatabaseService {
  _Databases(this._db) : super(AppPathsService());
  final ContentDatabase _db;

  @override
  ContentDatabase get content => _db;
}

void main() {
  group('FtsQueryBuilder', () {
    test('quotes each word as a prefix term joined with OR', () {
      expect(FtsQueryBuilder.build('الشحن بالدلك'), '"الشحن"* OR "بالدلك"*');
    });

    test('drops punctuation and one-letter words', () {
      expect(FtsQueryBuilder.build('ما هو الشحن؟ و!'), '"ما"* OR "هو"* OR "الشحن"*');
    });

    test('removes duplicates', () {
      expect(FtsQueryBuilder.build('شحن شحن'), '"شحن"*');
    });

    test('FTS syntax in user text cannot leak through', () {
      expect(FtsQueryBuilder.build('شحن" OR NOT *'), '"شحن"* OR "OR"* OR "NOT"*');
    });

    test('nothing searchable gives null', () {
      expect(FtsQueryBuilder.build('؟! ... '), isNull);
      expect(FtsQueryBuilder.build(''), isNull);
    });
  });

  group('SqliteChunkSearchDataSource (seed data)', () {
    late ContentDatabase db;
    late SqliteChunkSearchDataSource search;

    setUp(() async {
      db = ContentDatabase(NativeDatabase.memory());
      await ContentSeed.insert(db);
      search = SqliteChunkSearchDataSource(_Databases(db));
    });

    tearDown(() => db.close());

    test('keyword search finds the right chunk with a 0..1 score', () async {
      final hits = await search.keywordSearch(ArabicNormalizer.normalize('الإلكترونات'),
          subjectId: ContentSeed.subjectId, limit: 4);
      expect(hits, hasLength(1));
      expect(hits.single.page, 12);
      expect(hits.single.score, inInclusiveRange(0.0, 1.0));
    });

    test('keyword search is scoped to the subject', () async {
      final hits = await search.keywordSearch('الالكترونات', subjectId: 'math', limit: 4);
      expect(hits, isEmpty);
    });

    test('keyword search can be scoped to a lesson', () async {
      final hits = await search.keywordSearch('الالكترونات',
          subjectId: ContentSeed.subjectId, lessonId: 'other-lesson', limit: 4);
      expect(hits, isEmpty);
    });

    test('a query with nothing searchable returns nothing, not an error', () async {
      expect(await search.keywordSearch('؟!', subjectId: ContentSeed.subjectId, limit: 4), isEmpty);
    });

    test('vector search ranks by cosine similarity (computed in an isolate)', () async {
      final hits = await search.vectorSearch([0, 1, 0],
          subjectId: ContentSeed.subjectId, limit: 3);
      expect(hits.first.page, 13);
      expect(hits.first.score, closeTo(1.0, 1e-6));
      expect(hits.skip(1).every((h) => h.score == 0), isTrue);
    });

    test('vector search honors the limit and the subject', () async {
      expect(
        await search.vectorSearch([1, 0, 0], subjectId: ContentSeed.subjectId, limit: 2),
        hasLength(2),
      );
      expect(await search.vectorSearch([1, 0, 0], subjectId: 'math', limit: 2), isEmpty);
    });
  });
}
