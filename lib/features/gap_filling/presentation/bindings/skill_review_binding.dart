import 'package:get/get.dart';

import '../../domain/usecases/get_skill_review_usecase.dart';
import '../../domain/usecases/submit_skill_review_usecase.dart';
import '../controllers/skill_progress_signal.dart';
import '../controllers/skill_review_controller.dart';
import '../routes/skill_review_args.dart';
import 'gap_filling_binding.dart';

class SkillReviewBinding extends Bindings {
  @override
  void dependencies() {
    GapFillingBinding().dependencies();
    final args = SkillReviewArgs.from(Get.arguments);
    Get.lazyPut(() => SkillReviewController(
          Get.find<GetSkillReviewUseCase>(),
          Get.find<SubmitSkillReviewUseCase>(),
          Get.find<SkillProgressSignal>(),
          args: args,
        ));
  }
}
