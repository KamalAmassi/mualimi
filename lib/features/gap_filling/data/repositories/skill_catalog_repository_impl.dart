import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diagnostic_question.dart';
import '../../domain/entities/question_kind.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_need.dart';
import '../../domain/repositories/skill_catalog_repository.dart';
import '../datasources/skill_catalog_local_data_source.dart';

class SkillCatalogRepositoryImpl implements SkillCatalogRepository {
  SkillCatalogRepositoryImpl(this._local);
  final SkillCatalogLocalDataSource _local;

  @override
  Future<Either<Failure, List<SkillNeed>>> getSkillNeeds() =>
      _guard(_local.needs);

  @override
  Future<Either<Failure, List<SkillNeed>>> getLessonNeeds(String lessonId) =>
      _guard(() => _local.needs(lessonId: lessonId));

  @override
  Future<Either<Failure, Map<String, String>>> getSubjectNames() =>
      _guard(_local.subjectNames);

  @override
  Future<Either<Failure, List<DiagnosticQuestion>>> getQuestions(
          QuestionKind kind,
          {String? skillId}) =>
      _guard(() => _local.questions(kind, skillId: skillId));

  @override
  Future<Either<Failure, Skill>> getSkill(String skillId) =>
      _guard(() => _local.skill(skillId));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() read) async {
    try {
      return Right(await read());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on FormatException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
