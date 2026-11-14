import 'package:get/get.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../subjects/domain/entities/subject.dart';
import '../../../subjects/domain/usecases/get_subjects_usecase.dart';

/// Which subject and lesson the student is asking about.
class TutorSelection {
  TutorSelection(this._getSubjects);

  final GetSubjectsUseCase _getSubjects;

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
