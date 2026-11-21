import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/core/services/app_paths_service.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/features/gap_filling/data/datasources/skill_catalog_local_data_source.dart';
import 'package:mualimi/features/gap_filling/data/datasources/skill_progress_local_data_source.dart';
import 'package:mualimi/features/gap_filling/data/repositories/skill_catalog_repository_impl.dart';
import 'package:mualimi/features/gap_filling/data/repositories/skill_progress_repository_impl.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/finish_diagnostic_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/get_diagnostic_plans_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/get_learning_path_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/get_lesson_prerequisites_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/get_skill_review_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/save_diagnostic_answers_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/start_diagnostic_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/submit_skill_review_usecase.dart';

class GapFillingDatabases extends DatabaseService {
  GapFillingDatabases(this._content, this._user) : super(AppPathsService());
  final ContentDatabase _content;
  final UserDatabase _user;

  @override
  ContentDatabase get content => _content;

  @override
  UserDatabase get user => _user;
}

/// The gap-filling stack over in-memory databases holding the development seed.
class GapFillingHarness {
  late GapFillingDatabases databases;
  late ContentDatabase content;
  late UserDatabase user;
  late SkillCatalogRepositoryImpl catalog;
  late SkillProgressRepositoryImpl progress;
  late GetDiagnosticPlansUseCase plans;
  late StartDiagnosticUseCase start;
  late SaveDiagnosticAnswersUseCase saveAnswers;
  late FinishDiagnosticUseCase finish;
  late GetLearningPathUseCase path;
  late GetLessonPrerequisitesUseCase lessonPrerequisites;
  late GetSkillReviewUseCase review;
  late SubmitSkillReviewUseCase submit;

  Future<void> open() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    content = ContentDatabase(NativeDatabase.memory());
    await DevSeedScienceG9.insert(content);
    user = UserDatabase(NativeDatabase.memory());
    databases = GapFillingDatabases(content, user);
    catalog = SkillCatalogRepositoryImpl(SkillCatalogLocalDataSource(databases));
    progress = SkillProgressRepositoryImpl(SkillProgressLocalDataSource(databases));
    plans = GetDiagnosticPlansUseCase(catalog);
    start = StartDiagnosticUseCase(plans, progress);
    saveAnswers = SaveDiagnosticAnswersUseCase(progress);
    finish = FinishDiagnosticUseCase(catalog, progress);
    path = GetLearningPathUseCase(catalog, progress);
    lessonPrerequisites = GetLessonPrerequisitesUseCase(catalog, progress);
    review = GetSkillReviewUseCase(catalog);
    submit = SubmitSkillReviewUseCase(progress);
  }

  Future<void> close() async {
    await content.close();
    await user.close();
  }
}
