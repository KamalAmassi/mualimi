import '../../domain/services/question_tokenizer.dart';

/// Turns a normalized question into a safe FTS5 MATCH expression.
abstract final class FtsQueryBuilder {
  /// Each meaningful word becomes a quoted prefix term, joined with OR; null
  /// if nothing searchable remains. Quoting stops user text from being
  /// parsed as FTS syntax.
  static String? build(String normalizedQuestion) {
    final terms =
        QuestionTokenizer.tokens(normalizedQuestion).map((t) => '"$t"*');
    return terms.isEmpty ? null : terms.join(' OR ');
  }
}
