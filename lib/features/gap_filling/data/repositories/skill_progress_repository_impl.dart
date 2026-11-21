import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diagnostic_answer.dart';
import '../../domain/entities/diagnostic_attempt.dart';
import '../../domain/entities/skill_mastery.dart';
import '../../domain/repositories/skill_progress_repository.dart';
import '../datasources/skill_progress_local_data_source.dart';

class SkillProgressRepositoryImpl implements SkillProgressRepository {
  SkillProgressRepositoryImpl(this._local);
  final SkillProgressLocalDataSource _local;

  @override
  Future<Either<Failure, List<SkillMastery>>> getMastery() =>
      _guard(_local.mastery);

  @override
  Future<Either<Failure, Unit>> saveMastery(SkillMastery mastery) =>
      _guard(() async {
        await _local.saveMastery(mastery);
        return unit;
      });

  @override
  Future<Either<Failure, bool>> hasFinishedDiagnostic() =>
      _guard(_local.hasFinishedDiagnostic);

  @override
  Future<Either<Failure, List<DiagnosticAttempt>>> getUnfinishedAttempts() =>
      _guard(_local.unfinishedAttempts);

  @override
  Future<Either<Failure, DiagnosticAttempt>> startAttempt(
          String subjectId, DateTime startedAt) =>
      _guard(() => _local.startAttempt(subjectId, startedAt));

  @override
  Future<Either<Failure, Unit>> saveAnswers(
          int attemptId, List<DiagnosticAnswer> answers) =>
      _guard(() async {
        await _local.saveAnswers(attemptId, answers);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> completeAttempt({
    required int attemptId,
    required DateTime finishedAt,
    required List<DiagnosticAnswer> answers,
    required String resultJson,
    required List<String> skillIds,
    required List<SkillMastery> mastery,
  }) =>
      _guard(() async {
        await _local.completeAttempt(
          attemptId: attemptId,
          finishedAt: finishedAt,
          answers: answers,
          resultJson: resultJson,
          skillIds: skillIds,
          mastery: mastery,
        );
        return unit;
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Right(await run());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
