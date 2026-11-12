import 'package:get/get.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../domain/usecases/cancel_download_usecase.dart';
import '../../domain/usecases/download_artifacts_usecase.dart';
import '../../domain/usecases/get_manifest_usecase.dart';
import '../../domain/usecases/pause_download_usecase.dart';
import '../../domain/usecases/resume_download_usecase.dart';
import '../controllers/model_download_controller.dart';
import '../controllers/pack_download_controller.dart';
import 'content_manager_binding.dart';
import 'download_binding.dart';

/// Controllers that must outlive individual screens once the shell is up:
/// the model download (it keeps going while the student browses) and the
/// pack update sheet.
class ContentManagerShellBinding extends Bindings {
  @override
  void dependencies() {
    ContentManagerBinding().dependencies();
    Get.lazyPut<PackDownloadController>(
      () => DownloadBinding.packController(autoStart: false),
      fenix: true,
    );
    Get.lazyPut<ModelDownloadController>(
      () => ModelDownloadController(
        download: Get.find<DownloadArtifactsUseCase>(),
        pause: Get.find<PauseDownloadUseCase>(),
        resume: Get.find<ResumeDownloadUseCase>(),
        cancel: Get.find<CancelDownloadUseCase>(),
        connectivity: Get.find<ConnectivityService>(),
        getManifest: Get.find<GetManifestUseCase>(),
        engine: Get.find<TutorEngineService>(),
      ),
      fenix: true,
    );
  }
}
