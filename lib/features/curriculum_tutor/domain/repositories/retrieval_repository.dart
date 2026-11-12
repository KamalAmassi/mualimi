import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/retrieved_chunk.dart';

abstract class RetrievalRepository {
  /// Keyword (FTS5) matches. Scores are 0..1.
  Future<Either<Failure, List<RetrievedChunk>>> searchKeywords(
    String normalizedQuery, {
    required String subjectId,
    String? lessonId,
    required int limit,
  });

  /// Embedding-similarity matches. Right(empty) when no embedding model is
  /// available, so callers fall back to keywords alone.
  Future<Either<Failure, List<RetrievedChunk>>> searchSemantic(
    String question, {
    required String subjectId,
    String? lessonId,
    required int limit,
  });
}
