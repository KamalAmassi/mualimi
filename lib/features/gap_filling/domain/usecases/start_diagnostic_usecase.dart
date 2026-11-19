import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diagnostic_attempt.dart';
import '../entities/diagnostic_session.dart';
import '../repositories/skill_progress_repository.dart';
import 'get_diagnostic_plans_usecase.dart';

/// Opens the diagnostic: resumes the unfinished attempt of each subject or
/// starts a new one.
class StartDiagnosticUseCase implements UseCase<DiagnosticSession, NoParams> {
  StartDiagnosticUseCase(this._plans, this._progress, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final GetDiagnosticPlansUseCase _plans;
  final SkillProgressRepository _progress;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, DiagnosticSession>> call(NoParams params) async {
    final plans = await _plans(params);
    final open = await _progress.getUnfinishedAttempts();
    return plans.fold(
      (failure) => Left(failure),
      (subjects) async => open.fold<Future<Either<Failure, DiagnosticSession>>>(
        (failure) async => Left(failure),
        (unfinished) async {
          final attempts = <String, DiagnosticAttempt>{
            for (final a in unfinished) a.subjectId: a,
          };
          for (final plan in subjects) {
            if (attempts.containsKey(plan.subjectId)) continue;
            final started =
                await _progress.startAttempt(plan.subjectId, _now());
            final failure = started.fold<Failure?>((f) => f, (a) {
              attempts[plan.subjectId] = a;
              return null;
            });
            if (failure != null) return Left(failure);
          }
          return Right(DiagnosticSession(plans: subjects, attempts: attempts));
        },
      ),
    );
  }
}
