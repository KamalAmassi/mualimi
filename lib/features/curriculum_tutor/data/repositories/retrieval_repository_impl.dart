import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/retrieved_chunk.dart';
import '../../domain/repositories/retrieval_repository.dart';
import '../datasources/chunk_search_data_source.dart';
import '../datasources/embedding_data_source.dart';

class RetrievalRepositoryImpl implements RetrievalRepository {
  RetrievalRepositoryImpl(this._search, this._embeddings);

  final ChunkSearchDataSource _search;
  final EmbeddingDataSource _embeddings;

  @override
  Future<Either<Failure, List<RetrievedChunk>>> searchKeywords(
    String normalizedQuery, {
    required String subjectId,
    String? lessonId,
    required int limit,
  }) =>
      _guard(() => _search.keywordSearch(normalizedQuery,
          subjectId: subjectId, lessonId: lessonId, limit: limit));

  @override
  Future<Either<Failure, List<RetrievedChunk>>> searchSemantic(
    String question, {
    required String subjectId,
    String? lessonId,
    required int limit,
  }) async {
    List<double>? vector;
    try {
      vector = await _embeddings.embedQuery(question);
    } catch (_) {
      // A failing embedder must not break the question: use keywords alone.
      vector = null;
    }
    if (vector == null) return const Right([]);
    final query = vector;
    return _guard(() => _search.vectorSearch(query,
        subjectId: subjectId, lessonId: lessonId, limit: limit));
  }

  Future<Either<Failure, List<RetrievedChunk>>> _guard(
      Future<List<RetrievedChunk>> Function() run) async {
    try {
      return Right(await run());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
