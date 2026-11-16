import 'package:get/get.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../subjects/domain/entities/lesson_summary.dart';
import '../../../subjects/domain/entities/subject.dart';
import '../../../subjects/domain/entities/subject_unit.dart';
import '../../../subjects/domain/usecases/get_subject_detail_usecase.dart';
import '../../../subjects/domain/usecases/get_subjects_usecase.dart';
import 'tutor_selection.dart';

/// Backs the "choose subject and lesson" sheet. Reuses the subjects feature's
/// use cases; the tutor never reads content tables for this itself.
class LessonPickerController extends GetxController {
  LessonPickerController(this._getSubjects, this._getDetail, this._selection);

  final GetSubjectsUseCase _getSubjects;
  final GetSubjectDetailUseCase _getDetail;
  final TutorSelection _selection;

  final subjects = <Subject>[].obs;
  final units = <SubjectUnit>[].obs;
  final selectedSubject = Rxn<Subject>();

  /// Null means "the whole subject".
  final selectedLessonId = RxnString();

  Future<void> load() async {
    final result = await _getSubjects(const NoParams());
    result.fold((_) => subjects.clear(), subjects.assignAll);
    selectedLessonId.value = _selection.lessonId.value;
    final current =
        subjects.firstWhereOrNull((s) => s.id == _selection.subjectId.value);
    if (current != null) await pickSubject(current, keepLesson: true);
  }

  Future<void> pickSubject(Subject subject, {bool keepLesson = false}) async {
    if (!subject.tutorEnabled) return;
    selectedSubject.value = subject;
    if (!keepLesson) selectedLessonId.value = null;
    final result = await _getDetail(subject.id);
    result.fold(
        (_) => units.clear(), (detail) => units.assignAll(detail.units));
  }

  void pickLesson(LessonSummary lesson) => selectedLessonId.value = lesson.id;

  void pickWholeSubject() => selectedLessonId.value = null;

  void confirm() {
    final subject = selectedSubject.value;
    if (subject != null) {
      final lesson = _lessonById(selectedLessonId.value);
      _selection.select(
        subject: subject.id,
        lesson: lesson?.id,
        title: lesson?.title,
        tutorEnabled: subject.tutorEnabled && (lesson?.tutorEnabled ?? true),
      );
    }
    Get.back<void>();
  }

  LessonSummary? _lessonById(String? id) {
    for (final unit in units) {
      for (final lesson in unit.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }
}
