import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/usecases/save_grade_usecase.dart';
import '../widgets/grade_strings.dart';

class GradeController extends GetxController {
  GradeController(this._saveGrade);
  final SaveGradeUseCase _saveGrade;

  /// MVP: only grade 9 is offered.
  final availableGrades = AppConfig.availableGrades;
  final selected = RxnInt();

  /// The name saved on the welcome step, passed as the route argument.
  final String studentName = Get.arguments is String ? Get.arguments as String : '';

  String get title => GradeStrings.title(studentName);

  String get downloadLabel {
    final grade = selected.value;
    return grade == null ? AppStrings.download : GradeStrings.downloadLabel(grade);
  }

  bool isAvailable(int grade) => availableGrades.contains(grade);

  void select(int grade) {
    if (isAvailable(grade)) selected.value = grade;
  }

  Future<void> next() async {
    final grade = selected.value;
    if (grade == null) return;
    await _saveGrade(grade);
    Get.toNamed<void>(AppRoutes.download);
  }
}
