import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../content_manager/presentation/constants/grade_ordinals.dart';
import '../../domain/entities/continue_lesson.dart';
import '../../domain/entities/student_summary.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_continue_lesson_usecase.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/watch_online_usecase.dart';
import '../../domain/usecases/watch_student_usecase.dart';
import '../widgets/home_strings.dart';

class HomeController extends GetxController {
  HomeController(
    this._getSubjects,
    this._getContinueLesson,
    this._watchStudent,
    this._watchOnline, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final GetSubjectsUseCase _getSubjects;
  final GetContinueLessonUseCase _getContinueLesson;
  final WatchStudentUseCase _watchStudent;
  final WatchOnlineUseCase _watchOnline;
  final DateTime Function() _now;

  static const _afternoonHour = 12;

  final subjects = <Subject>[].obs;
  final continueLesson = Rxn<ContinueLesson>();
  final student = const StudentSummary(name: '', grade: null).obs;
  final online = false.obs;
  final failure = Rxn<Failure>();

  final _subscriptions = <StreamSubscription<Object?>>[];

  String get greeting =>
      _now().hour < _afternoonHour ? HomeStrings.morningGreeting : HomeStrings.eveningGreeting;

  String? get gradeLabel {
    final grade = student.value.grade;
    return grade == null ? null : '${AppStrings.gradePrefix} ${GradeOrdinals.of(grade)}';
  }

  @override
  void onInit() {
    super.onInit();
    _subscriptions
      ..add(_watchStudent(const NoParams()).listen((s) => student.value = s))
      ..add(_watchOnline(const NoParams()).listen((o) => online.value = o));
  }

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final result = await _getSubjects(const NoParams());
    result.fold((f) => failure.value = f, (list) {
      failure.value = null;
      subjects.assignAll(list);
    });
    await refreshContinueLesson();
  }

  Future<void> refreshContinueLesson() async {
    final result = await _getContinueLesson(const NoParams());
    continueLesson.value = result.fold((_) => null, (lesson) => lesson);
  }

  Future<void> open(Subject subject) async {
    await Get.toNamed<void>(AppRoutes.subjectOf(subject.id));
    await refreshContinueLesson();
  }

  Future<void> openContinueLesson() async {
    final lesson = continueLesson.value;
    if (lesson == null) return;
    await Get.toNamed<void>(AppRoutes.lessonOf(lesson.lessonId));
    await refreshContinueLesson();
  }

  @override
  void onClose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.onClose();
  }
}
