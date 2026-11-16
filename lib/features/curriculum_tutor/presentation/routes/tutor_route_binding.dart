import 'package:get/get.dart';

import '../../../subjects/presentation/bindings/subjects_binding.dart';
import '../bindings/tutor_binding.dart';
import '../controllers/tutor_controller.dart';
import 'tutor_args.dart';

/// Wires the tutor for `AppRoutes.tutor` and applies the route arguments.
class TutorRouteBinding extends Bindings {
  @override
  void dependencies() {
    SubjectsBinding().dependencies();
    TutorBinding().dependencies();
    Get.find<TutorController>().openWith(TutorArgs.from(Get.arguments));
  }
}
