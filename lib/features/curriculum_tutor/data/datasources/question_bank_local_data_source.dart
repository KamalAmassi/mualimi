import 'package:drift/drift.dart';

import '../../domain/entities/answer_source.dart';
import '../../domain/entities/bank_entry.dart';
import 'content_access.dart';
import 'fts_query_builder.dart';

/// Candidate lookup in the pack's question bank (`question_bank_fts`).
class QuestionBankLocalDataSource {
  QuestionBankLocalDataSource(this._content);

  final ContentAccess _content;

  static const candidateLimit = 10;

  Future<List<String>> exampleQuestions(
    String subjectId, {
    String? lessonId,
    required int limit,
  }) async {
    Future<List<String>> query(String? lesson) async {
      final rows = await _content().customSelect(
        'SELECT question FROM question_bank WHERE subject_id = ? '
        '${lesson == null ? '' : 'AND lesson_id = ? '}ORDER BY id LIMIT ?',
        variables: [
          Variable.withString(subjectId),
          if (lesson != null) Variable.withString(lesson),
          Variable.withInt(limit),
        ],
      ).get();
      return [for (final r in rows) r.read<String>('question')];
    }

    if (lessonId != null) {
      final inLesson = await query(lessonId);
      if (inLesson.isNotEmpty) return inLesson;
    }
    return query(null);
  }

  Future<List<BankEntry>> candidates(String normalizedQuestion,
      {required String subjectId}) async {
    final match = FtsQueryBuilder.build(normalizedQuestion);
    if (match == null) return const [];
    final rows = await _content().customSelect(
      'SELECT q.id, q.question_normalized, q.answer, q.printed_page, q.lesson_id, '
      'l.title AS lesson_title, l.subject_id AS subject_id, s.name AS subject_name, '
      'c.pdf_page AS pdf_page '
      'FROM question_bank_fts '
      'JOIN question_bank q ON q.id = question_bank_fts.rowid '
      'JOIN lessons l ON l.id = q.lesson_id '
      'JOIN subjects s ON s.id = l.subject_id '
      'LEFT JOIN chunks c ON c.id = ('
      'SELECT MIN(id) FROM chunks WHERE lesson_id = q.lesson_id AND printed_page = q.printed_page) '
      'WHERE question_bank_fts MATCH ? AND q.subject_id = ? '
      'ORDER BY bm25(question_bank_fts) LIMIT ?',
      variables: [
        Variable.withString(match),
        Variable.withString(subjectId),
        Variable.withInt(candidateLimit),
      ],
    ).get();
    return [
      for (final r in rows)
        BankEntry(
          id: r.read<int>('id'),
          questionNormalized: r.read<String>('question_normalized'),
          answer: r.read<String>('answer'),
          source: AnswerSource(
            subjectId: r.read<String>('subject_id'),
            subjectName: r.read<String>('subject_name'),
            lessonId: r.read<String>('lesson_id'),
            lessonTitle: r.read<String>('lesson_title'),
            printedPage: r.read<String>('printed_page'),
            pdfPage: r.readNullable<int>('pdf_page') ?? 0,
          ),
        ),
    ];
  }
}
