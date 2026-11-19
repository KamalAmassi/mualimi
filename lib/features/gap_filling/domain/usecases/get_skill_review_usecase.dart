import 'package:dartz/dartz.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/question_kind.dart';
import '../entities/skill_review.dart';
import '../repositories/skill_catalog_repository.dart';

class GetSkillReviewUseCase implements UseCase<SkillReview, String> {
  GetSkillReviewUseCase(this._catalog);
  final SkillCatalogRepository _catalog;

  @override
  Future<Either<Failure, SkillReview>> call(String skillId) async {
    final skill = await _catalog.getSkill(skillId);
    final questions =
        await _catalog.getQuestions(QuestionKind.review, skillId: skillId);
    return skill.flatMap((s) => questions.map((all) => SkillReview(
          skill: s,
          questions: all.take(Limits.reviewQuestionsPerSkill).toList(),
        )));
  }
}
