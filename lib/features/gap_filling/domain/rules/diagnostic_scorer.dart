import '../entities/diagnostic_answer.dart';
import '../entities/mastery_source.dart';
import '../entities/skill_mastery.dart';
import '../entities/subject_diagnostic.dart';

abstract final class DiagnosticScorer {
  /// One mastery per skill that was asked and answered:
  /// `round(correct / asked * 100)`. A skill that was not asked gets none.
  static List<SkillMastery> score(
    SubjectDiagnostic plan,
    Map<int, DiagnosticAnswer> answers,
    DateTime now,
  ) {
    final asked = <String, int>{};
    final correct = <String, int>{};
    for (final q in plan.questions) {
      final answer = answers[q.id];
      if (answer == null) continue;
      asked.update(q.skillId, (n) => n + 1, ifAbsent: () => 1);
      if (q.isCorrect(answer.choiceIndex)) {
        correct.update(q.skillId, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    return [
      for (final MapEntry(key: skillId, value: count) in asked.entries)
        SkillMastery(
          skillId: skillId,
          score: percent(correct[skillId] ?? 0, count),
          source: MasterySource.diagnostic,
          updatedAt: now,
        ),
    ];
  }

  static int percent(int correct, int asked) =>
      asked == 0 ? 0 : (correct / asked * 100).round();
}
