import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../shell/presentation/controllers/shell_controller.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/usecases/get_last_section_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/save_lesson_progress_usecase.dart';
import 'viewer_tab.dart';

class LessonController extends GetxController {
  LessonController(this._getLesson, this._getLastSection, this._saveProgress, this._connectivity);

  final GetLessonUseCase _getLesson;
  final GetLastSectionUseCase _getLastSection;
  final SaveLessonProgressUseCase _saveProgress;
  final ConnectivityService _connectivity;

  final lesson = Rxn<Lesson>();
  final failure = Rxn<Failure>();
  final currentSection = 0.obs;

  String get lessonId => Get.parameters['id'] ?? '';

  /// Videos stream from YouTube, so they need a connection. Reads the
  /// reactive network state, so it updates inside an `Obx`.
  bool get videoAvailable => _connectivity.isOnline;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final result = await _getLesson(lessonId);
    await result.fold((f) async => failure.value = f, (l) async {
      failure.value = null;
      lesson.value = l;
      currentSection.value = await _getLastSection(l.id);
    });
  }

  Future<void> selectSection(int index) async {
    currentSection.value = index;
    await _saveProgress(lessonId, index);
  }

  void openViewer(ViewerTab tab) =>
      Get.toNamed<void>(AppRoutes.viewerOf(lessonId, tab: tab.name));

  void openKeyTerms() => Get.toNamed<void>(AppRoutes.keyTermsOf(lessonId));

  /// Hands over to the tutor tab; disabled in the UI when the lesson's
  /// subject has `tutorEnabled == false`.
  void askTutor() => Get.find<ShellController>().openTutor();
}
