import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../content_manager/presentation/constants/grade_ordinals.dart';
import '../../../curriculum_tutor/presentation/routes/tutor_args.dart';
import '../../domain/entities/lesson_summary.dart';
import '../../domain/entities/student_summary.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/subject_unit.dart';
import '../../domain/usecases/get_last_opened_lesson_usecase.dart';
import '../../domain/usecases/get_subject_detail_usecase.dart';
import '../../domain/usecases/watch_student_usecase.dart';
import '../widgets/subject_strings.dart';

class SubjectController extends GetxController {
  SubjectController(this._getDetail, this._getLastOpened, this._watchStudent);
  final GetSubjectDetailUseCase _getDetail;
  final GetLastOpenedLessonUseCase _getLastOpened;
  final WatchStudentUseCase _watchStudent;

  final subject = Rxn<Subject>();
  final units = <SubjectUnit>[].obs;
  final failure = Rxn<Failure>();
  final loaded = false.obs;
  final lastOpenedLessonId = RxnString();
  final student = const StudentSummary(name: '', grade: null).obs;

  /// Units are collapsible; this tracks the open ones.
  final expanded = <String>{}.obs;

  StreamSubscription<StudentSummary>? _studentSubscription;

  /// Read once: `Get.parameters` follows the top route, so it holds the lesson's
  /// id after a lesson is pushed on top of this page.
  late final String subjectId;

  bool get canAskTutor => subject.value?.tutorEnabled ?? false;

  bool get isEmpty => loaded.value && units.every((u) => u.lessons.isEmpty);

  String get headerSubtitle {
    final grade = student.value.grade;
    return [
      if (grade != null) '${AppStrings.gradePrefix} ${GradeOrdinals.of(grade)}',
      SubjectStrings.unitsCount(units.length),
    ].join(SubjectStrings.separator);
  }

  @override
  void onInit() {
    super.onInit();
    subjectId = Get.parameters['id'] ?? '';
    _studentSubscription = _watchStudent(const NoParams()).listen((s) => student.value = s);
  }

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final (result, _) = await (_getDetail(subjectId), _refreshLastOpened()).wait;
    result.fold((f) {
      failure.value = f;
      loaded.value = false;
    }, (detail) {
      failure.value = null;
      subject.value = detail.subject;
      units.assignAll(detail.units);
      final initial = _initialUnitId(detail.units);
      expanded.assignAll({if (initial != null) initial});
      loaded.value = true;
    });
  }

  void toggle(String unitId) =>
      expanded.contains(unitId) ? expanded.remove(unitId) : expanded.add(unitId);

  Future<void> openLesson(LessonSummary lesson) async {
    await Get.toNamed<void>(AppRoutes.lessonOf(lesson.id));
    await _refreshLastOpened();
  }

  void askTutor() =>
      Get.toNamed<void>(AppRoutes.tutor, arguments: TutorArgs(subjectId: subjectId));

  /// The unit holding the last opened lesson, else the first unit.
  String? _initialUnitId(List<SubjectUnit> list) {
    final lessonId = lastOpenedLessonId.value;
    for (final unit in list) {
      if (unit.lessons.any((l) => l.id == lessonId)) return unit.id;
    }
    return list.isEmpty ? null : list.first.id;
  }

  Future<void> _refreshLastOpened() async {
    final result = await _getLastOpened(subjectId);
    lastOpenedLessonId.value = result.fold((_) => null, (id) => id);
  }

  @override
  void onClose() {
    _studentSubscription?.cancel();
    super.onClose();
  }
}
