import 'dart:isolate';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart' as app;
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/vector_codec.dart';
import '../../../../core/utils/vector_math.dart';
import '../../domain/entities/retrieved_chunk.dart';
import 'chunk_search_data_source.dart';
import 'fts_query_builder.dart';

class SqliteChunkSearchDataSource implements ChunkSearchDataSource {
  SqliteChunkSearchDataSource(this._databases);
  final DatabaseService _databases;

  @override
  Future<List<RetrievedChunk>> keywordSearch(
    String normalizedQuery, {
    required String subjectId,
    String? lessonId,
    required int limit,
  }) async {
    final match = FtsQueryBuilder.build(normalizedQuery);
    if (match == null) return const [];

    final rows = await _db().customSelect(
      'SELECT c.id, c.lesson_id, c.page, c.text, bm25(chunks_fts) AS rank '
      'FROM chunks_fts '
      'JOIN chunks c ON c.id = chunks_fts.rowid '
      'JOIN lessons l ON l.id = c.lesson_id '
      'WHERE chunks_fts MATCH ? AND l.subject_id = ? '
      '${lessonId == null ? '' : 'AND c.lesson_id = ? '}'
      'ORDER BY rank LIMIT ?',
      variables: [
        Variable.withString(match),
        Variable.withString(subjectId),
        if (lessonId != null) Variable.withString(lessonId),
        Variable.withInt(limit),
      ],
    ).get();

    return [
      for (final r in rows)
        RetrievedChunk(
          id: r.read<int>('id'),
          lessonId: r.read<String>('lesson_id'),
          page: r.read<int>('page'),
          text: r.read<String>('text'),
          // bm25() is negative, more negative = better match.
          score: (-r.read<double>('rank') / Limits.bm25Saturation).clamp(0.0, 1.0),
        ),
    ];
  }

  @override
  Future<List<RetrievedChunk>> vectorSearch(
    List<double> queryVector, {
    required String subjectId,
    String? lessonId,
    required int limit,
  }) async {
    final rows = await _db().customSelect(
      'SELECT c.id, c.lesson_id, c.page, c.text, v.vector '
      'FROM chunk_vectors v '
      'JOIN chunks c ON c.id = v.chunk_id '
      'JOIN lessons l ON l.id = c.lesson_id '
      'WHERE l.subject_id = ? ${lessonId == null ? '' : 'AND c.lesson_id = ?'}',
      variables: [
        Variable.withString(subjectId),
        if (lessonId != null) Variable.withString(lessonId),
      ],
    ).get();

    final candidates = [
      for (final r in rows)
        (
          r.read<int>('id'),
          r.read<String>('lesson_id'),
          r.read<int>('page'),
          r.read<String>('text'),
          r.read<Uint8List>('vector'),
        ),
    ];
    final ranked = await Isolate.run(() => _rank(candidates, queryVector, limit));
    return ranked;
  }

  ContentDatabase _db() {
    try {
      return _databases.content;
    } on StateError catch (e) {
      throw app.DatabaseException(e.message);
    }
  }
}

typedef _Candidate = (int, String, int, String, Uint8List);

/// Runs in a worker isolate: decoding and scoring every vector is CPU work.
List<RetrievedChunk> _rank(List<_Candidate> candidates, List<double> query, int limit) {
  final scored = [
    for (final (id, lessonId, page, text, blob) in candidates)
      RetrievedChunk(
        id: id,
        lessonId: lessonId,
        page: page,
        text: text,
        score: max(0.0, VectorMath.cosine(query, VectorCodec.decode(blob))),
      ),
  ]..sort((a, b) => b.score.compareTo(a.score));
  return scored.take(limit).toList();
}
