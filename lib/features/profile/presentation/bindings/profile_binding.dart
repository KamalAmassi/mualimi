import 'package:get/get.dart';

import '../../../../core/services/settings_service.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/change_grade_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import '../../domain/usecases/update_student_name_usecase.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(
        () => ProfileRepositoryImpl(Get.find<SettingsService>()), fenix: true);
    Get.lazyPut(() => GetProfileUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => UpdateStudentNameUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => ChangeGradeUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => SetThemeModeUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(
      () => ProfileController(
        Get.find<GetProfileUseCase>(),
        Get.find<UpdateStudentNameUseCase>(),
        Get.find<ChangeGradeUseCase>(),
        Get.find<SetThemeModeUseCase>(),
      ),
      fenix: true,
    );
  }
}
