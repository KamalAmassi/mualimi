import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/skill.dart';
import '../repositories/skill_catalog_repository.dart';
import '../repositories/skill_progress_repository.dart';
import '../rules/learning_path_builder.dart';

/// The weak skills among the prerequisites of a lesson.
class GetLessonPrerequisitesUseCase implements UseCase<List<Skill>, String> {
  GetLessonPrerequisitesUseCase(this._catalog, this._progress);
  final SkillCatalogRepository _catalog;
  final SkillProgressRepository _progress;

  @override
  Future<Either<Failure, List<Skill>>> call(String lessonId) async {
    final needs = await _catalog.getLessonNeeds(lessonId);
    final mastery = await _progress.getMastery();
    return needs.flatMap(
        (n) => mastery.map((m) => LearningPathBuilder.weakSkills(n, m)));
  }
}
