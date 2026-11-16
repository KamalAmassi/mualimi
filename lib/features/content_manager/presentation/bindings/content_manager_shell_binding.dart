import 'package:get/get.dart';

import '../controllers/pack_download_controller.dart';
import 'content_manager_binding.dart';
import 'download_binding.dart';

/// Controllers that must outlive individual screens once the shell is up:
/// the pack update sheet.
class ContentManagerShellBinding extends Bindings {
  @override
  void dependencies() {
    ContentManagerBinding().dependencies();
    Get.lazyPut<PackDownloadController>(
      () => DownloadBinding.packController(autoStart: false),
      fenix: true,
    );
  }
}
