import 'package:get/get.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/usecases/cancel_download_usecase.dart';
import '../../domain/usecases/check_pack_update_usecase.dart';
import '../../domain/usecases/download_artifacts_usecase.dart';
import '../../domain/usecases/get_manifest_usecase.dart';
import '../../domain/usecases/pause_download_usecase.dart';
import '../../domain/usecases/resume_download_usecase.dart';
import '../controllers/pack_download_controller.dart';
import 'content_manager_binding.dart';

/// Binding for `/download` (onboarding step 3/3, or a grade change from
/// Profile): starts downloading the current grade's pack on open.
class DownloadBinding extends Bindings {
  @override
  void dependencies() {
    ContentManagerBinding().dependencies();
    attach(() => packController(autoStart: true));
  }

  /// First run: registers a controller that starts itself in `onReady`.
  /// Once the shell is up it has already registered one (GetX ignores a second
  /// registration of the same type), so that one is told to start instead —
  /// in a microtask, after the route's build, so no Rx changes mid-build.
  static void attach(PackDownloadController Function() create) {
    if (!Get.isRegistered<PackDownloadController>()) {
      Get.lazyPut(create);
      return;
    }
    final controller = Get.find<PackDownloadController>();
    Future.microtask(controller.startForCurrentGrade);
  }

  /// Shared with the shell binding, which needs the same controller for the
  /// pack update sheet.
  static PackDownloadController packController({required bool autoStart}) =>
      PackDownloadController(
        download: Get.find<DownloadArtifactsUseCase>(),
        pause: Get.find<PauseDownloadUseCase>(),
        resume: Get.find<ResumeDownloadUseCase>(),
        cancel: Get.find<CancelDownloadUseCase>(),
        connectivity: Get.find<ConnectivityService>(),
        getManifest: Get.find<GetManifestUseCase>(),
        checkUpdate: Get.find<CheckPackUpdateUseCase>(),
        settings: Get.find<SettingsService>(),
        autoStart: autoStart,
      );
}
