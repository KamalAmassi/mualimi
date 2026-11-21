import '../../../../core/constants/limits.dart';
import 'diagnostic_scorer.dart';

abstract final class ReviewScorer {
  /// A review can only raise a score: `max(old, round(correct / asked * 100))`.
  static int nextScore({int? old, required int correct, required int asked}) {
    final reviewed = DiagnosticScorer.percent(correct, asked);
    return old != null && old > reviewed ? old : reviewed;
  }

  static bool isWeak(int score) => score < Limits.weakSkillThreshold;
}
