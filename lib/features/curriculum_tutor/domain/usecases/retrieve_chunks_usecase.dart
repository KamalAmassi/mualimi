import 'package:dartz/dartz.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/retrieved_chunk.dart';
import '../repositories/retrieval_repository.dart';
import 'ask_tutor_params.dart';

/// Hybrid search: keyword (FTS5) and embedding similarity, merged by chunk.
/// [AskTutorParams.question] must already be normalized.
class RetrieveChunksUseCase implements UseCase<List<RetrievedChunk>, AskTutorParams> {
  RetrieveChunksUseCase(this._repository);
  final RetrievalRepository _repository;

  @override
  Future<Either<Failure, List<RetrievedChunk>>> call(AskTutorParams p) async {
    // Fetch extra candidates from each side so the merge has room to re-rank.
    const pool = Limits.retrievalMaxChunks * 3;
    final keyword = await _repository.searchKeywords(p.question,
        subjectId: p.subjectId, lessonId: p.lessonId, limit: pool);
    final semantic = await _repository.searchSemantic(p.question,
        subjectId: p.subjectId, lessonId: p.lessonId, limit: pool);

    return keyword.flatMap((k) => semantic.map((s) => merge(k, s)));
  }

  /// Weighted blend over the signals that returned results: with no
  /// embedding model, the keyword score stands alone instead of being halved.
  static List<RetrievedChunk> merge(List<RetrievedChunk> keyword, List<RetrievedChunk> semantic) {
    final wK = keyword.isEmpty ? 0.0 : Limits.ftsWeight;
    final wS = semantic.isEmpty ? 0.0 : Limits.vectorWeight;
    final total = wK + wS;
    if (total == 0) return const [];
    // One signal only: keep its scores exactly (blending would just add
    // floating-point drift right at the out-of-scope threshold).
    if (wS == 0) return _top(keyword);
    if (wK == 0) return _top(semantic);

    final k = {for (final c in keyword) c.id: c};
    final s = {for (final c in semantic) c.id: c};
    final merged = <RetrievedChunk>[
      for (final id in {...k.keys, ...s.keys})
        (k[id] ?? s[id]!).withScore(
          (wK * (k[id]?.score ?? 0) + wS * (s[id]?.score ?? 0)) / total,
        ),
    ];
    return _top(merged);
  }

  static List<RetrievedChunk> _top(List<RetrievedChunk> chunks) {
    final sorted = [...chunks]..sort((a, b) => b.score.compareTo(a.score));
    return sorted.take(Limits.retrievalMaxChunks).toList();
  }
}
