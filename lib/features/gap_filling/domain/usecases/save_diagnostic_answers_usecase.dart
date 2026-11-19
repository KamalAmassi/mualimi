import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diagnostic_answer.dart';
import '../repositories/skill_progress_repository.dart';

class SaveDiagnosticAnswersParams extends Equatable {
  const SaveDiagnosticAnswersParams(this.attemptId, this.answers);

  final int attemptId;
  final List<DiagnosticAnswer> answers;

  @override
  List<Object?> get props => [attemptId, answers];
}

/// Stores the answers given so far so an interrupted diagnostic can resume.
class SaveDiagnosticAnswersUseCase
    implements UseCase<Unit, SaveDiagnosticAnswersParams> {
  SaveDiagnosticAnswersUseCase(this._progress);
  final SkillProgressRepository _progress;

  @override
  Future<Either<Failure, Unit>> call(SaveDiagnosticAnswersParams params) =>
      _progress.saveAnswers(params.attemptId, params.answers);
}
