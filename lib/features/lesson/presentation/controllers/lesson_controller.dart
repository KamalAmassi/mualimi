import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../curriculum_tutor/presentation/routes/tutor_args.dart';
import '../../domain/entities/key_term.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/usecases/get_key_terms_usecase.dart';
import '../../domain/usecases/get_last_section_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import '../../domain/usecases/save_lesson_progress_usecase.dart';
import '../widgets/lesson_hub_strings.dart';
import 'viewer_tab.dart';

/// Backs the lesson hub at `/lesson/:id`.
class LessonController extends GetxController {
  LessonController(
    this._getLesson,
    this._getKeyTerms,
    this._isTutorEnabled,
    this._getLastSection,
    this._saveProgress,
  );

  final GetLessonUseCase _getLesson;
  final GetKeyTermsUseCase _getKeyTerms;
  final IsLessonTutorEnabledUseCase _isTutorEnabled;
  final GetLastSectionUseCase _getLastSection;
  final SaveLessonProgressUseCase _saveProgress;

  final lesson = Rxn<Lesson>();
  final keyTerms = <KeyTerm>[].obs;
  final failure = Rxn<Failure>();
  final loading = true.obs;
  final tutorEnabled = false.obs;

  /// Read once, on first use while this page is on top: `Get.parameters`
  /// follows the newest route and is not restored on back.
  late final String lessonId = Get.parameters['id'] ?? '';

  bool get hasPdf => lesson.value?.pdfFile?.isNotEmpty ?? false;

  bool get hasContent =>
      hasPdf || (lesson.value?.sections.isNotEmpty ?? false) || keyTerms.isNotEmpty;

  /// The printed pages the lesson covers in the book.
  String? get pageRange {
    final l = lesson.value;
    return l == null ? null : LessonHubStrings.pages(l.bookPagesFrom, l.bookPagesTo);
  }

  String get subtitle {
    final l = lesson.value;
    return l == null ? '' : LessonHubStrings.join([l.subjectName, l.unitTitle, pageRange]);
  }

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    failure.value = null;
    final result = await _getLesson(lessonId);
    await result.fold((f) async => failure.value = f, (l) async {
      lesson.value = l;
      _recordOpened(l.id).ignore();
      tutorEnabled.value = await _isTutorEnabled(l);
      final terms = await _getKeyTerms(l.id);
      keyTerms.assignAll(terms.getOrElse(() => const []));
    });
    loading.value = false;
  }

  /// Re-saves the current section so this lesson becomes the most recently
  /// opened one; a failed write must not affect the page.
  Future<void> _recordOpened(String id) async => _saveProgress(id, await _getLastSection(id));

  void openViewer(ViewerTab tab) =>
      Get.toNamed<void>(AppRoutes.viewerOf(lessonId, tab: tab.name));

  void openKeyTerms() => Get.toNamed<void>(AppRoutes.keyTermsOf(lessonId));

  /// Opens the tutor on top of the lesson when both the lesson and its
  /// subject enable it.
  void askTutor() {
    final l = lesson.value;
    if (l == null || !tutorEnabled.value) return;
    Get.toNamed<void>(
      AppRoutes.tutor,
      arguments: TutorArgs(subjectId: l.subjectId, lessonId: l.id),
    );
  }
}
