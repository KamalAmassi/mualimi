import 'package:get/get.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../subjects/domain/entities/lesson_summary.dart';
import '../../../subjects/domain/entities/subject.dart';
import '../../../subjects/domain/entities/subject_unit.dart';
import '../../../subjects/domain/usecases/get_subject_detail_usecase.dart';
import '../../../subjects/domain/usecases/get_subjects_usecase.dart';
import '../routes/tutor_args.dart';

/// Which subject and lesson the student is asking about.
class TutorSelection {
  TutorSelection(this._getSubjects, this._getDetail);

  final GetSubjectsUseCase _getSubjects;
  final GetSubjectDetailUseCase _getDetail;

  final subjects = <Subject>[].obs;
  final subjectId = RxnString();
  final lessonId = RxnString();
  final lessonTitle = RxnString();

  /// False for subjects and lessons the tutor can't handle yet (math).
  final supported = true.obs;

  bool get hasLesson => lessonId.value != null;

  String get subjectName {
    for (final s in subjects) {
      if (s.id == subjectId.value) return s.name;
    }
    return '';
  }

  /// Loads the subject list and picks the first tutor-enabled subject when
  /// nothing is selected yet.
  Future<void> load() async {
    final result = await _getSubjects(const NoParams());
    result.fold((_) => subjects.clear(), subjects.assignAll);
    if (subjectId.value != null || subjects.isEmpty) return;
    final first = subjects.firstWhere((s) => s.tutorEnabled,
        orElse: () => subjects.first);
    select(subject: first.id, tutorEnabled: first.tutorEnabled);
  }

  /// Pre-selects the subject and lesson of the route arguments. Unknown
  /// subjects leave the selection alone; an unknown lesson falls back to the
  /// whole subject.
  Future<void> applyArgs(TutorArgs args) async {
    final result = await _getSubjects(const NoParams());
    result.fold((_) => subjects.clear(), subjects.assignAll);
    final subject = subjects.firstWhereOrNull((s) => s.id == args.subjectId);
    if (subject == null) return;
    LessonSummary? lesson;
    if (args.lessonId != null) {
      final detail = await _getDetail(subject.id);
      lesson =
          detail.fold((_) => null, (d) => _findLesson(d.units, args.lessonId!));
    }
    select(
      subject: subject.id,
      lesson: lesson?.id,
      title: lesson?.title,
      tutorEnabled: subject.tutorEnabled && (lesson?.tutorEnabled ?? true),
    );
  }

  LessonSummary? _findLesson(List<SubjectUnit> units, String id) {
    for (final unit in units) {
      for (final lesson in unit.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }

  void select({
    required String subject,
    String? lesson,
    String? title,
    required bool tutorEnabled,
  }) {
    subjectId.value = subject;
    lessonId.value = lesson;
    lessonTitle.value = title;
    supported.value = tutorEnabled;
  }

  void clearLesson() {
    lessonId.value = null;
    lessonTitle.value = null;
  }
}
