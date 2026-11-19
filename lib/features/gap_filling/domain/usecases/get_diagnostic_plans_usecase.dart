import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/question_kind.dart';
import '../entities/subject_diagnostic.dart';
import '../repositories/skill_catalog_repository.dart';
import '../rules/diagnostic_planner.dart';

/// The subjects that have a diagnostic and the questions for each.
class GetDiagnosticPlansUseCase
    implements UseCase<List<SubjectDiagnostic>, NoParams> {
  GetDiagnosticPlansUseCase(this._catalog);
  final SkillCatalogRepository _catalog;

  @override
  Future<Either<Failure, List<SubjectDiagnostic>>> call(NoParams params) async {
    final names = await _catalog.getSubjectNames();
    final needs = await _catalog.getSkillNeeds();
    final questions = await _catalog.getQuestions(QuestionKind.diagnostic);
    return names.fold(
      Left.new,
      (subjectNames) => needs.fold(
        Left.new,
        (skillNeeds) => questions.map((all) => DiagnosticPlanner.plan(
            subjectNames: subjectNames, needs: skillNeeds, questions: all)),
      ),
    );
  }
}
