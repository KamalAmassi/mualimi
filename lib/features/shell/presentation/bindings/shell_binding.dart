import 'package:get/get.dart';

import '../../../../core/services/tutor_engine_service.dart';
import '../../../content_manager/presentation/bindings/content_manager_shell_binding.dart';
import '../../../curriculum_tutor/presentation/bindings/tutor_binding.dart';
import '../../../profile/presentation/bindings/profile_binding.dart';
import '../../../subjects/presentation/bindings/subjects_binding.dart';
import '../controllers/shell_controller.dart';

/// Everything the three tabs need, wired once when `/shell` opens.
class ShellBinding extends Bindings {
  @override
  void dependencies() {
    SubjectsBinding().dependencies();
    ContentManagerShellBinding().dependencies();
    ProfileBinding().dependencies();
    TutorBinding().dependencies();
    Get.lazyPut(() => ShellController(Get.find<TutorEngineService>()), fenix: true);
  }
}
