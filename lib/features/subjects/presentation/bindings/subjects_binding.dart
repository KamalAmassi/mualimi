import 'package:get/get.dart';

import '../../../../core/services/database_service.dart';
import '../../data/datasources/subjects_local_data_source.dart';
import '../../data/repositories/subjects_repository_impl.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../../domain/usecases/get_subject_detail_usecase.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../controllers/home_controller.dart';
import '../controllers/subject_controller.dart';

/// Registers the subjects dependencies; used by the shell (home tab) and /subject/:id.
class SubjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectsRepository>(
      () => SubjectsRepositoryImpl(SubjectsLocalDataSource(Get.find<DatabaseService>())),
      fenix: true,
    );
    Get.lazyPut(() => GetSubjectsUseCase(Get.find<SubjectsRepository>()), fenix: true);
    Get.lazyPut(() => GetSubjectDetailUseCase(Get.find<SubjectsRepository>()), fenix: true);
    Get.lazyPut(() => HomeController(Get.find<GetSubjectsUseCase>()), fenix: true);
    Get.lazyPut(() => SubjectController(Get.find<GetSubjectDetailUseCase>()));
  }
}
