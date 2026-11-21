import 'package:get/get.dart';

import '../../domain/usecases/finish_diagnostic_usecase.dart';
import '../../domain/usecases/get_diagnostic_plans_usecase.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';
import '../../domain/usecases/save_diagnostic_answers_usecase.dart';
import '../../domain/usecases/start_diagnostic_usecase.dart';
import '../controllers/diagnostic_controller.dart';
import '../controllers/skill_progress_signal.dart';
import '../routes/diagnostic_args.dart';
import 'gap_filling_binding.dart';

class DiagnosticBinding extends Bindings {
  @override
  void dependencies() {
    GapFillingBinding().dependencies();
    final args = DiagnosticArgs.from(Get.arguments);
    Get.lazyPut(() => DiagnosticController(
          Get.find<GetDiagnosticPlansUseCase>(),
          Get.find<StartDiagnosticUseCase>(),
          Get.find<SaveDiagnosticAnswersUseCase>(),
          Get.find<FinishDiagnosticUseCase>(),
          Get.find<GetLearningPathUseCase>(),
          Get.find<SkillProgressSignal>(),
          entry: args.entry,
        ));
  }
}
