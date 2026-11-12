import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/usecases/save_grade_usecase.dart';

class GradeController extends GetxController {
  GradeController(this._saveGrade);
  final SaveGradeUseCase _saveGrade;

  /// MVP: only grade 9 is offered.
  final availableGrades = AppConfig.availableGrades;
  final selected = RxnInt();

  void select(int grade) => selected.value = grade;

  Future<void> next() async {
    final grade = selected.value;
    if (grade == null) return;
    await _saveGrade(grade);
    Get.toNamed<void>(AppRoutes.download);
  }
}
