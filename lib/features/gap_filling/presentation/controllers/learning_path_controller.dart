import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/skill.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';
import '../routes/diagnostic_args.dart';
import '../routes/skill_review_args.dart';
import 'skill_progress_signal.dart';

/// Feeds the "مسارك" card on Home.
class LearningPathController extends GetxController {
  LearningPathController(this._getPath, this._signal);

  final GetLearningPathUseCase _getPath;
  final SkillProgressSignal _signal;

  final path = Rxn<LearningPath>();
  Worker? _watch;

  @override
  void onInit() {
    super.onInit();
    _watch = ever(_signal.version, (_) => load());
    load();
  }

  Future<void> load() async {
    final loaded = await _getPath(const NoParams());
    loaded.fold((_) => path.value = null, (found) => path.value = found);
  }

  void openDiagnostic() => Get.toNamed(AppRoutes.diagnostic,
      arguments: const DiagnosticArgs(entry: DiagnosticEntry.profile));

  void openReview(Skill skill) => Get.toNamed(AppRoutes.skillReview,
      arguments: SkillReviewArgs(skillId: skill.id));

  @override
  void onClose() {
    _watch?.dispose();
    super.onClose();
  }
}
