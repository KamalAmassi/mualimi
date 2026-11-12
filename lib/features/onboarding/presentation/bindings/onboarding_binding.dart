import 'package:get/get.dart';

import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/get_start_route_usecase.dart';
import '../../domain/usecases/save_grade_usecase.dart';
import '../../domain/usecases/save_student_name_usecase.dart';
import '../controllers/grade_controller.dart';
import '../controllers/welcome_controller.dart';

/// Shared by /welcome and /grade (see [SplashBinding] for /splash).
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingRepository>(
      () => OnboardingRepositoryImpl(Get.find<SettingsService>(), Get.find<DatabaseService>()),
      fenix: true,
    );
    Get.lazyPut(() => GetStartRouteUseCase(Get.find<OnboardingRepository>()));
    Get.lazyPut(() => SaveStudentNameUseCase(Get.find<OnboardingRepository>()));
    Get.lazyPut(() => SaveGradeUseCase(Get.find<OnboardingRepository>()));
    Get.lazyPut(() => WelcomeController(Get.find<SaveStudentNameUseCase>()));
    Get.lazyPut(() => GradeController(Get.find<SaveGradeUseCase>()));
  }
}
