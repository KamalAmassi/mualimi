import '../../domain/entities/retrieved_chunk.dart';

abstract class ChunkSearchDataSource {
  /// FTS5 matches scored 0..1 from bm25.
  Future<List<RetrievedChunk>> keywordSearch(
    String normalizedQuery, {
    required String subjectId,
    String? lessonId,
    required int limit,
  });

  /// Cosine-similarity matches scored 0..1, computed off the UI isolate.
  Future<List<RetrievedChunk>> vectorSearch(
    List<double> queryVector, {
    required String subjectId,
    String? lessonId,
    required int limit,
  });
}
