import 'package:get/get.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../subjects/domain/entities/lesson_summary.dart';
import '../../../subjects/domain/entities/subject.dart';
import '../../../subjects/domain/entities/subject_unit.dart';
import '../../../subjects/domain/usecases/get_subject_detail_usecase.dart';
import '../../../subjects/domain/usecases/get_subjects_usecase.dart';
import 'tutor_controller.dart';

/// Backs the "choose subject and lesson" sheet. Reuses the subjects feature's
/// use cases; the tutor never reads content tables for this itself.
class LessonPickerController extends GetxController {
  LessonPickerController(this._getSubjects, this._getDetail, this._tutor);

  final GetSubjectsUseCase _getSubjects;
  final GetSubjectDetailUseCase _getDetail;
  final TutorController _tutor;

  final subjects = <Subject>[].obs;
  final units = <SubjectUnit>[].obs;
  final selectedSubject = Rxn<Subject>();

  Future<void> load() async {
    selectedSubject.value = null;
    units.clear();
    final result = await _getSubjects(const NoParams());
    result.fold((_) => subjects.clear(), subjects.assignAll);
  }

  Future<void> pickSubject(Subject subject) async {
    selectedSubject.value = subject;
    final result = await _getDetail(subject.id);
    result.fold((_) => units.clear(), (detail) => units.assignAll(detail.units));
  }

  /// Ask about the whole subject, not one lesson.
  void useWholeSubject() {
    final subject = selectedSubject.value;
    if (subject == null) return;
    _tutor.selectLesson(subject: subject.id, tutorEnabled: subject.tutorEnabled);
    Get.back<void>();
  }

  void pickLesson(LessonSummary lesson) {
    final subject = selectedSubject.value;
    if (subject == null) return;
    _tutor.selectLesson(
      subject: subject.id,
      lesson: lesson.id,
      title: lesson.title,
      tutorEnabled: subject.tutorEnabled && lesson.tutorEnabled,
    );
    Get.back<void>();
  }
}
