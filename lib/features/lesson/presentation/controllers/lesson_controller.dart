import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../curriculum_tutor/presentation/routes/tutor_args.dart';
import '../../domain/entities/key_term.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/usecases/get_key_terms_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import '../widgets/lesson_hub_strings.dart';
import 'viewer_tab.dart';

/// Backs the lesson hub at `/lesson/:id`.
class LessonController extends GetxController {
  LessonController(this._getLesson, this._getKeyTerms, this._isTutorEnabled);

  final GetLessonUseCase _getLesson;
  final GetKeyTermsUseCase _getKeyTerms;
  final IsLessonTutorEnabledUseCase _isTutorEnabled;

  final lesson = Rxn<Lesson>();
  final keyTerms = <KeyTerm>[].obs;
  final failure = Rxn<Failure>();
  final loading = true.obs;
  final tutorEnabled = false.obs;

  String get lessonId => Get.parameters['id'] ?? '';

  bool get hasPdf => lesson.value?.pdfFile?.isNotEmpty ?? false;

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
      tutorEnabled.value = await _isTutorEnabled(l);
      final terms = await _getKeyTerms(l.id);
      keyTerms.assignAll(terms.getOrElse(() => const []));
    });
    loading.value = false;
  }

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
