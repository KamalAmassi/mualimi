import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diagnostic_answer.dart';
import '../entities/diagnostic_session.dart';
import '../entities/subject_diagnostic_result.dart';
import '../repositories/skill_catalog_repository.dart';
import '../repositories/skill_progress_repository.dart';
import '../rules/diagnostic_scorer.dart';
import '../rules/learning_path_builder.dart';

class FinishDiagnosticParams {
  const FinishDiagnosticParams(this.session, this.answers);

  final DiagnosticSession session;

  /// Every answer given, keyed by question id.
  final Map<int, DiagnosticAnswer> answers;
}

/// Scores each subject, replaces the stored scores of its skills and closes
/// the attempts.
class FinishDiagnosticUseCase
    implements UseCase<List<SubjectDiagnosticResult>, FinishDiagnosticParams> {
  FinishDiagnosticUseCase(this._catalog, this._progress,
      {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final SkillCatalogRepository _catalog;
  final SkillProgressRepository _progress;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, List<SubjectDiagnosticResult>>> call(
      FinishDiagnosticParams params) async {
    final needsResult = await _catalog.getSkillNeeds();
    final needsFailure = needsResult.fold<Failure?>((f) => f, (_) => null);
    if (needsFailure != null) return Left(needsFailure);
    final needs = needsResult.getOrElse(() => const []);
    final now = _now();
    final results = <SubjectDiagnosticResult>[];
    for (final plan in params.session.plans) {
      final attempt = params.session.attempts[plan.subjectId];
      if (attempt == null) continue;
      final mastery = DiagnosticScorer.score(plan, params.answers, now);
      final answers = [
        for (final q in plan.questions)
          if (params.answers[q.id] != null) params.answers[q.id]!,
      ];
      final saved = await _progress.completeAttempt(
        attemptId: attempt.id,
        finishedAt: now,
        answers: answers,
        resultJson: jsonEncode({
          for (final m in mastery) m.skillId: m.score,
        }),
        skillIds: plan.skillIds,
        mastery: mastery,
      );
      final failure = saved.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) return Left(failure);
      final subjectNeeds = [
        for (final n in needs)
          if (plan.skillIds.contains(n.skill.id)) n,
      ];
      results.add(SubjectDiagnosticResult(
        subjectId: plan.subjectId,
        subjectName: plan.subjectName,
        strongSkillCount: mastery.where((m) => !m.isWeak).length,
        weakSkills: LearningPathBuilder.weakSkills(subjectNeeds, mastery),
      ));
    }
    return Right(results);
  }
}
