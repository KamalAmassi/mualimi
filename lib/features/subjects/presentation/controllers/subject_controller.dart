import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/lesson_summary.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/subject_unit.dart';
import '../../domain/usecases/get_subject_detail_usecase.dart';

class SubjectController extends GetxController {
  SubjectController(this._getDetail);
  final GetSubjectDetailUseCase _getDetail;

  final subject = Rxn<Subject>();
  final units = <SubjectUnit>[].obs;
  final failure = Rxn<Failure>();

  /// Units are collapsible; this tracks the open ones.
  final expanded = <String>{}.obs;

  String get subjectId => Get.parameters['id'] ?? '';

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final result = await _getDetail(subjectId);
    result.fold((f) => failure.value = f, (detail) {
      failure.value = null;
      subject.value = detail.subject;
      units.assignAll(detail.units);
      if (detail.units.isNotEmpty) expanded.add(detail.units.first.id);
    });
  }

  void toggle(String unitId) =>
      expanded.contains(unitId) ? expanded.remove(unitId) : expanded.add(unitId);

  void openLesson(LessonSummary lesson) => Get.toNamed<void>(AppRoutes.lessonOf(lesson.id));
}
