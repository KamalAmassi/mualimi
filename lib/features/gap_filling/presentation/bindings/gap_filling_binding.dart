import 'package:get/get.dart';

import '../../../../core/services/database_service.dart';
import '../../data/datasources/skill_catalog_local_data_source.dart';
import '../../data/datasources/skill_progress_local_data_source.dart';
import '../../data/repositories/skill_catalog_repository_impl.dart';
import '../../data/repositories/skill_progress_repository_impl.dart';
import '../../domain/repositories/skill_catalog_repository.dart';
import '../../domain/repositories/skill_progress_repository.dart';
import '../../domain/usecases/finish_diagnostic_usecase.dart';
import '../../domain/usecases/get_diagnostic_plans_usecase.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';
import '../../domain/usecases/get_lesson_prerequisites_usecase.dart';
import '../../domain/usecases/get_skill_review_usecase.dart';
import '../../domain/usecases/save_diagnostic_answers_usecase.dart';
import '../../domain/usecases/start_diagnostic_usecase.dart';
import '../../domain/usecases/submit_skill_review_usecase.dart';
import '../controllers/skill_progress_signal.dart';

/// Repositories, use cases and the progress signal shared by every gap
/// filling screen and by the cards other features place. Safe to call again.
class GapFillingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SkillProgressSignal>()) {
      Get.put(SkillProgressSignal(), permanent: true);
    }
    Get.lazyPut<SkillCatalogRepository>(
      () => SkillCatalogRepositoryImpl(
          SkillCatalogLocalDataSource(Get.find<DatabaseService>())),
      fenix: true,
    );
    Get.lazyPut<SkillProgressRepository>(
      () => SkillProgressRepositoryImpl(
          SkillProgressLocalDataSource(Get.find<DatabaseService>())),
      fenix: true,
    );
    Get.lazyPut(() => GetDiagnosticPlansUseCase(Get.find<SkillCatalogRepository>()),
        fenix: true);
    Get.lazyPut(
        () => StartDiagnosticUseCase(Get.find<GetDiagnosticPlansUseCase>(),
            Get.find<SkillProgressRepository>()),
        fenix: true);
    Get.lazyPut(
        () => SaveDiagnosticAnswersUseCase(Get.find<SkillProgressRepository>()),
        fenix: true);
    Get.lazyPut(
        () => FinishDiagnosticUseCase(Get.find<SkillCatalogRepository>(),
            Get.find<SkillProgressRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetLearningPathUseCase(Get.find<SkillCatalogRepository>(),
            Get.find<SkillProgressRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetLessonPrerequisitesUseCase(Get.find<SkillCatalogRepository>(),
            Get.find<SkillProgressRepository>()),
        fenix: true);
    Get.lazyPut(() => GetSkillReviewUseCase(Get.find<SkillCatalogRepository>()),
        fenix: true);
    Get.lazyPut(
        () => SubmitSkillReviewUseCase(Get.find<SkillProgressRepository>()),
        fenix: true);
  }
}
