import 'package:get/get.dart';

import '../../domain/usecases/get_start_route_usecase.dart';
import '../controllers/splash_controller.dart';
import 'onboarding_binding.dart';

/// The splash page never reads its controller, so a lazy controller would
/// never be created and the app would never leave the splash. `Get.put`
/// creates it immediately so its `onReady` can navigate.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    OnboardingBinding().dependencies();
    Get.put(SplashController(Get.find<GetStartRouteUseCase>()));
  }
}
