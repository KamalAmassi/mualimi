import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../curriculum_tutor/presentation/routes/tutor_args.dart';
import '../../domain/entities/book_solution.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_section.dart';
import '../../domain/entities/reading_font_scale.dart';
import '../../domain/usecases/get_book_solutions_usecase.dart';
import '../../domain/usecases/get_font_scale_usecase.dart';
import '../../domain/usecases/get_last_section_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import '../../domain/usecases/save_font_scale_usecase.dart';
import '../../domain/usecases/save_lesson_progress_usecase.dart';
import 'viewer_tab.dart';

/// Backs `/viewer/:lessonId?tab=` (explanation / book PDF / solutions).
class ViewerController extends GetxController {
  ViewerController(
    this._getLesson,
    this._getSolutions,
    this._getLastSection,
    this._saveProgress,
    this._getFontScale,
    this._saveFontScale,
    this._isTutorEnabled,
  );

  final GetLessonUseCase _getLesson;
  final GetBookSolutionsUseCase _getSolutions;
  final GetLastSectionUseCase _getLastSection;
  final SaveLessonProgressUseCase _saveProgress;
  final GetFontScaleUseCase _getFontScale;
  final SaveFontScaleUseCase _saveFontScale;
  final IsLessonTutorEnabledUseCase _isTutorEnabled;

  final tab = ViewerTab.explanation.obs;
  final lesson = Rxn<Lesson>();
  final solutions = <BookSolution>[].obs;
  final failure = Rxn<Failure>();
  final loading = true.obs;
  final sectionIndex = 0.obs;
  final tutorEnabled = false.obs;
  final fontScale = 1.0.obs;

  String get lessonId => Get.parameters['lessonId'] ?? '';

  List<LessonSection> get sections => lesson.value?.sections ?? const [];
  LessonSection? get currentSection => sections.isEmpty ? null : sections[sectionIndex.value];
  bool get canGoPrevious => sectionIndex.value > 0;
  bool get canGoNext => sectionIndex.value < sections.length - 1;

  @override
  void onInit() {
    super.onInit();
    tab.value = ViewerTab.parse(Get.parameters['tab']);
    fontScale.value = _getFontScale();
  }

  @override
  void onReady() {
    super.onReady();
    load();
  }

  void select(ViewerTab value) => tab.value = value;

  Future<void> load() async {
    loading.value = true;
    failure.value = null;
    final lessonResult = await _getLesson(lessonId);
    await lessonResult.fold((f) async => failure.value = f, (l) async {
      final saved = await _getLastSection(l.id);
      sectionIndex.value = l.sections.isEmpty ? 0 : saved.clamp(0, l.sections.length - 1);
      lesson.value = l;
      tutorEnabled.value = await _isTutorEnabled(l);
    });
    final solutionsResult = await _getSolutions(lessonId);
    solutionsResult.fold((f) => failure.value ??= f, solutions.assignAll);
    loading.value = false;
  }

  Future<void> goToPrevious() => _goTo(sectionIndex.value - 1);

  Future<void> goToNext() => _goTo(sectionIndex.value + 1);

  Future<void> _goTo(int index) async {
    final l = lesson.value;
    if (l == null || index < 0 || index >= l.sections.length) return;
    sectionIndex.value = index;
    await _saveProgress(l.id, index);
  }

  Future<void> cycleFontScale() async {
    final next = ReadingFontScale.next(fontScale.value);
    fontScale.value = next;
    await _saveFontScale(next);
  }

  void explainSection() {
    final l = lesson.value;
    if (l == null || !tutorEnabled.value) return;
    Get.toNamed<void>(
      AppRoutes.tutor,
      arguments: TutorArgs(subjectId: l.subjectId, lessonId: l.id),
    );
  }
}
