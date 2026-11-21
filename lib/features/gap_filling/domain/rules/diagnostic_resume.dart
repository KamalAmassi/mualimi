import '../entities/subject_diagnostic.dart';

abstract final class DiagnosticResume {
  /// Position of the first question without an answer, as subject index and
  /// question index. Null when everything is answered.
  static (int, int)? firstUnanswered(
      List<SubjectDiagnostic> plans, Set<int> answeredQuestionIds) {
    for (final (p, plan) in plans.indexed) {
      for (final (q, question) in plan.questions.indexed) {
        if (!answeredQuestionIds.contains(question.id)) return (p, q);
      }
    }
    return null;
  }
}
