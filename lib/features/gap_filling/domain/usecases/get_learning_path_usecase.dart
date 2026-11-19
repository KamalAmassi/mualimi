import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/learning_path.dart';
import '../repositories/skill_catalog_repository.dart';
import '../repositories/skill_progress_repository.dart';
import '../rules/learning_path_builder.dart';

class GetLearningPathUseCase implements UseCase<LearningPath, NoParams> {
  GetLearningPathUseCase(this._catalog, this._progress);
  final SkillCatalogRepository _catalog;
  final SkillProgressRepository _progress;

  @override
  Future<Either<Failure, LearningPath>> call(NoParams params) async {
    final taken = await _progress.hasFinishedDiagnostic();
    final mastery = await _progress.getMastery();
    final needs = await _catalog.getSkillNeeds();
    return taken.flatMap((diagnosticTaken) => mastery.flatMap((m) => needs.map(
          (n) => LearningPath(
            diagnosticTaken: diagnosticTaken,
            weakSkills: LearningPathBuilder.weakSkills(n, m),
          ),
        )));
  }
}
