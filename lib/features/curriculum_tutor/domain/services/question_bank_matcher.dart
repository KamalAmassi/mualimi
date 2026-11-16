import '../../../../core/constants/limits.dart';
import '../entities/bank_entry.dart';
import '../entities/bank_match.dart';
import 'question_tokenizer.dart';

/// Scores stored questions against the student's question by token overlap.
class QuestionBankMatcher {
  const QuestionBankMatcher({this.threshold = Limits.bankMatchThreshold});

  final double threshold;

  /// The best candidate whose score reaches [threshold], or null.
  /// [normalizedQuestion] must already be normalized.
  BankMatch? best(String normalizedQuestion, List<BankEntry> candidates) {
    final query = QuestionTokenizer.tokens(normalizedQuestion).toSet();
    if (query.isEmpty) return null;
    BankMatch? best;
    for (final entry in candidates) {
      final score = jaccard(
          query, QuestionTokenizer.tokens(entry.questionNormalized).toSet());
      if (score >= threshold && (best == null || score > best.score)) {
        best = BankMatch(entry, score);
      }
    }
    return best;
  }

  static double jaccard(Set<String> a, Set<String> b) {
    if (a.isEmpty || b.isEmpty) return 0;
    final shared = a.intersection(b).length;
    return shared / (a.length + b.length - shared);
  }
}
