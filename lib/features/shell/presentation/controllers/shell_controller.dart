import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../../content_manager/presentation/widgets/pack_update_sheet.dart';

/// Owns the bottom-nav selection. Presentation-only feature: it has no
/// domain or data layer of its own.
class ShellController extends GetxController {
  ShellController(this._engine);
  final TutorEngineService _engine;

  static const subjectsTab = 0;
  static const tutorTab = 1;
  static const profileTab = 2;

  final index = subjectsTab.obs;

  @override
  void onReady() {
    super.onReady();
    showPackUpdateSheetIfAvailable();
  }

  void select(int tab) {
    index.value = tab;
    // The model is loaded into RAM only when the student reaches the tutor.
    if (tab == tutorTab) _engine.ensureLoaded();
  }

  /// Returns to the shell from any screen above it and shows the tutor tab.
  void openTutor() {
    Get.until((route) => route.settings.name == AppRoutes.shell);
    select(tutorTab);
  }
}
