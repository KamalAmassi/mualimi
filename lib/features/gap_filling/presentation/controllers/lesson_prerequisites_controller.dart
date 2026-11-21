import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/skill.dart';
import '../../domain/usecases/get_lesson_prerequisites_usecase.dart';
import '../routes/skill_review_args.dart';
import 'skill_progress_signal.dart';

/// Feeds the "before you start" card on the lesson page.
class LessonPrerequisitesController extends GetxController {
  LessonPrerequisitesController(this._getWeak, this._signal, this.lessonId);

  final GetLessonPrerequisitesUseCase _getWeak;
  final SkillProgressSignal _signal;
  final String lessonId;

  final skills = <Skill>[].obs;
  Worker? _watch;

  @override
  void onInit() {
    super.onInit();
    _watch = ever(_signal.version, (_) => load());
    load();
  }

  Future<void> load() async {
    final loaded = await _getWeak(lessonId);
    loaded.fold((_) => skills.clear(), skills.assignAll);
  }

  void openReview(Skill skill) => Get.toNamed(AppRoutes.skillReview,
      arguments: SkillReviewArgs(skillId: skill.id, lessonId: lessonId));

  @override
  void onClose() {
    _watch?.dispose();
    super.onClose();
  }
}
