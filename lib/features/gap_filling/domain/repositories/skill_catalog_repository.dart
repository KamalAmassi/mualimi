import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/diagnostic_question.dart';
import '../entities/question_kind.dart';
import '../entities/skill.dart';
import '../entities/skill_need.dart';

/// Skills, prerequisites and questions of the installed pack (content.db).
abstract class SkillCatalogRepository {
  /// Skills that at least one lesson of the installed pack depends on.
  Future<Either<Failure, List<SkillNeed>>> getSkillNeeds();

  Future<Either<Failure, List<SkillNeed>>> getLessonNeeds(String lessonId);

  /// Subject names by id, in the order subjects are listed.
  Future<Either<Failure, Map<String, String>>> getSubjectNames();

  Future<Either<Failure, List<DiagnosticQuestion>>> getQuestions(
      QuestionKind kind,
      {String? skillId});

  Future<Either<Failure, Skill>> getSkill(String skillId);
}
