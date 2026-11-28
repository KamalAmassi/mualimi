import 'package:get/get.dart';

import '../../../content_manager/domain/repositories/installed_content_repository.dart';
import '../../../content_manager/presentation/bindings/content_manager_binding.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/get_start_route_usecase.dart';
import '../controllers/splash_controller.dart';
import 'onboarding_binding.dart';

/// The splash page never reads its controller, so a lazy controller would
/// never be created and the app would never leave the splash. `Get.put`
/// creates it immediately so its `onReady` can navigate.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    ContentManagerBinding().dependencies();
    OnboardingBinding().dependencies();
    final startRoute = GetStartRouteUseCase(
        Get.find<OnboardingRepository>(), Get.find<InstalledContentRepository>());
    Get.put(SplashController(startRoute));
  }
}
