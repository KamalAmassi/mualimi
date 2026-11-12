import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/subject.dart';
import '../../domain/usecases/get_subjects_usecase.dart';

class HomeController extends GetxController {
  HomeController(this._getSubjects);
  final GetSubjectsUseCase _getSubjects;

  final subjects = <Subject>[].obs;
  final failure = Rxn<Failure>();

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
  }

  void open(Subject subject) => Get.toNamed<void>(AppRoutes.subjectOf(subject.id));
}
