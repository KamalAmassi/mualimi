import '../../../../core/constants/limits.dart';
import '../entities/diagnostic_question.dart';
import '../entities/question_kind.dart';
import '../entities/skill_need.dart';
import '../entities/subject_diagnostic.dart';
import 'skill_priority.dart';

abstract final class DiagnosticPlanner {
  /// One plan per subject that has prerequisite skills and at least one
  /// diagnostic question, in the order of [subjectNames].
  static List<SubjectDiagnostic> plan({
    required Map<String, String> subjectNames,
    required List<SkillNeed> needs,
    required List<DiagnosticQuestion> questions,
  }) {
    final plans = <SubjectDiagnostic>[];
    for (final MapEntry(key: subjectId, value: name) in subjectNames.entries) {
      final subjectNeeds = SkillPriority.sorted(
          needs.where((n) => n.skill.subjectId == subjectId));
      if (subjectNeeds.isEmpty) continue;
      final asked = _questionsFor(subjectNeeds, questions);
      if (asked.isEmpty) continue;
      plans.add(SubjectDiagnostic(
        subjectId: subjectId,
        subjectName: name,
        questions: asked,
        skillIds: [for (final n in subjectNeeds) n.skill.id],
      ));
    }
    return plans;
  }

  static List<DiagnosticQuestion> _questionsFor(
    List<SkillNeed> sortedNeeds,
    List<DiagnosticQuestion> questions,
  ) {
    final queues = <String, List<DiagnosticQuestion>>{};
    var total = 0;
    for (final need in sortedNeeds) {
      final room = Limits.diagnosticMaxQuestionsPerSubject - total;
      if (room <= 0) break;
      final own = questions
          .where((q) =>
              q.skillId == need.skill.id && q.kind == QuestionKind.diagnostic)
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id));
      final taken = own
          .take(Limits.diagnosticQuestionsPerSkill)
          .take(room)
          .toList();
      if (taken.isEmpty) continue;
      queues[need.skill.id] = taken;
      total += taken.length;
    }
    return _separateSameSkill(queues);
  }

  /// Repeatedly takes from the skill with most questions left, never the
  /// skill just shown unless no other is left. Ties go to the earlier skill.
  static List<DiagnosticQuestion> _separateSameSkill(
      Map<String, List<DiagnosticQuestion>> queues) {
    final ordered = <DiagnosticQuestion>[];
    String? last;
    while (queues.values.any((q) => q.isNotEmpty)) {
      final candidates = [
        for (final e in queues.entries)
          if (e.value.isNotEmpty) e
      ];
      final others = candidates.where((e) => e.key != last).toList();
      final pool = others.isEmpty ? candidates : others;
      var best = pool.first;
      for (final e in pool) {
        if (e.value.length > best.value.length) best = e;
      }
      ordered.add(best.value.removeAt(0));
      last = best.key;
    }
    return ordered;
  }
}
