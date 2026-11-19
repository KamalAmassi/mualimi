import 'package:get/get.dart';

/// Tells the Home path and lesson cards that scores changed, so they reload.
class SkillProgressSignal extends GetxService {
  final version = 0.obs;

  void changed() => version.value++;
}
