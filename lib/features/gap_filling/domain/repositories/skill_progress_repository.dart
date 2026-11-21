import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/diagnostic_answer.dart';
import '../entities/diagnostic_attempt.dart';
import '../entities/skill_mastery.dart';

/// What the student has shown they know (user.db).
abstract class SkillProgressRepository {
  Future<Either<Failure, List<SkillMastery>>> getMastery();

  Future<Either<Failure, Unit>> saveMastery(SkillMastery mastery);

  Future<Either<Failure, bool>> hasFinishedDiagnostic();

  Future<Either<Failure, List<DiagnosticAttempt>>> getUnfinishedAttempts();

  Future<Either<Failure, DiagnosticAttempt>> startAttempt(
      String subjectId, DateTime startedAt);

  Future<Either<Failure, Unit>> saveAnswers(
      int attemptId, List<DiagnosticAnswer> answers);

  /// Closes the attempt and replaces the stored scores of [skillIds] with
  /// [mastery], in one transaction.
  Future<Either<Failure, Unit>> completeAttempt({
    required int attemptId,
    required DateTime finishedAt,
    required List<DiagnosticAnswer> answers,
    required String resultJson,
    required List<String> skillIds,
    required List<SkillMastery> mastery,
  });
}
