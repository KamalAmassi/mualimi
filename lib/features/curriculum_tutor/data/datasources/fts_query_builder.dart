/// Turns a normalized question into a safe FTS5 MATCH expression.
abstract final class FtsQueryBuilder {
  static final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);
  static const _minTokenLength = 2;

  /// Each word becomes a quoted prefix term, joined with OR; null if nothing
  /// searchable remains. Quoting stops user text from being parsed as FTS syntax.
  static String? build(String normalizedQuestion) {
    final terms = normalizedQuestion
        .split(_nonWord)
        .where((t) => t.length >= _minTokenLength)
        .toSet()
        .map((t) => '"$t"*');
    return terms.isEmpty ? null : terms.join(' OR ');
  }
}
