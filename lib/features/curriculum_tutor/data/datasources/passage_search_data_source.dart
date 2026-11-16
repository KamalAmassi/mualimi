import 'package:drift/drift.dart';

import '../../../../core/constants/limits.dart';
import '../../domain/entities/passage.dart';
import 'content_access.dart';
import 'fts_query_builder.dart';

/// Full-text search over the pack's passages (`chunks_fts`).
class PassageSearchDataSource {
  PassageSearchDataSource(this._content);

  final ContentAccess _content;

  static const _select =
      'SELECT c.id, c.lesson_id, c.printed_page, c.pdf_page, c.text, '
      'l.title AS lesson_title, s.id AS subject_id, s.name AS subject_name';
  static const _joins = 'JOIN chunks c ON c.id = chunks_fts.rowid '
      'JOIN lessons l ON l.id = c.lesson_id '
      'JOIN subjects s ON s.id = l.subject_id';

  /// Searches the lesson first when [lessonId] is given and widens to the
  /// whole subject only if the lesson has no match.
  Future<List<Passage>> search(
    String normalizedQuestion, {
    required String subjectId,
    String? lessonId,
    int limit = Limits.maxPassages,
  }) async {
    final match = FtsQueryBuilder.build(normalizedQuestion);
    if (match == null) return const [];
    if (lessonId != null) {
      final inLesson = await _query(match, subjectId, lessonId, limit);
      if (inLesson.isNotEmpty) return inLesson;
    }
    return _query(match, subjectId, null, limit);
  }

  Future<List<Passage>> findByIds(List<int> ids) async {
    if (ids.isEmpty) return const [];
    final marks = List.filled(ids.length, '?').join(',');
    final rows = await _content().customSelect(
      '$_select FROM chunks c '
      'JOIN lessons l ON l.id = c.lesson_id JOIN subjects s ON s.id = l.subject_id '
      'WHERE c.id IN ($marks)',
      variables: [for (final id in ids) Variable.withInt(id)],
    ).get();
    final byId = {for (final r in rows) r.read<int>('id'): _passage(r, 0)};
    return [
      for (final id in ids)
        if (byId[id] != null) byId[id]!
    ];
  }

  /// Passages of one lesson in book order, stopping before [maxChars] is exceeded.
  Future<List<Passage>> lessonPassages(String lessonId,
      {required int maxChars}) async {
    final rows = await _content().customSelect(
      '$_select FROM chunks c '
      'JOIN lessons l ON l.id = c.lesson_id JOIN subjects s ON s.id = l.subject_id '
      'WHERE c.lesson_id = ? ORDER BY c.id',
      variables: [Variable.withString(lessonId)],
    ).get();
    final passages = <Passage>[];
    var used = 0;
    for (final r in rows) {
      final passage = _passage(r, 0);
      if (used + passage.text.length > maxChars && passages.isNotEmpty) break;
      passages.add(passage);
      used += passage.text.length;
    }
    return passages;
  }

  Future<List<Passage>> _query(
      String match, String subjectId, String? lessonId, int limit) async {
    final rows = await _content().customSelect(
      '$_select, bm25(chunks_fts) AS rank FROM chunks_fts $_joins '
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
        // bm25() is negative; more negative is a better match.
        _passage(r,
            (-r.read<double>('rank') / Limits.bm25Saturation).clamp(0.0, 1.0)),
    ];
  }

  Passage _passage(QueryRow r, double score) => Passage(
        id: r.read<int>('id'),
        subjectId: r.read<String>('subject_id'),
        subjectName: r.read<String>('subject_name'),
        lessonId: r.read<String>('lesson_id'),
        lessonTitle: r.read<String>('lesson_title'),
        printedPage: r.read<String>('printed_page'),
        pdfPage: r.read<int>('pdf_page'),
        text: r.read<String>('text'),
        score: score,
      );
}
