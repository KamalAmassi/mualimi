import 'package:get/get.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../data/datasources/subjects_local_data_source.dart';
import '../../data/repositories/continue_lesson_repository_impl.dart';
import '../../data/repositories/network_status_repository_impl.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../data/repositories/subjects_repository_impl.dart';
import '../../domain/repositories/continue_lesson_repository.dart';
import '../../domain/repositories/network_status_repository.dart';
import '../../domain/repositories/student_repository.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../../domain/usecases/get_continue_lesson_usecase.dart';
import '../../domain/usecases/get_last_opened_lesson_usecase.dart';
import '../../domain/usecases/get_subject_detail_usecase.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/watch_online_usecase.dart';
import '../../domain/usecases/watch_student_usecase.dart';
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
    Get.lazyPut<ContinueLessonRepository>(
      () => ContinueLessonRepositoryImpl(SubjectsLocalDataSource(Get.find<DatabaseService>())),
      fenix: true,
    );
    Get.lazyPut<StudentRepository>(
        () => StudentRepositoryImpl(Get.find<SettingsService>()), fenix: true);
    Get.lazyPut<NetworkStatusRepository>(
        () => NetworkStatusRepositoryImpl(Get.find<ConnectivityService>()), fenix: true);
    Get.lazyPut(() => GetSubjectsUseCase(Get.find<SubjectsRepository>()), fenix: true);
    Get.lazyPut(() => GetSubjectDetailUseCase(Get.find<SubjectsRepository>()), fenix: true);
    Get.lazyPut(() => GetContinueLessonUseCase(Get.find<ContinueLessonRepository>()), fenix: true);
    Get.lazyPut(() => WatchStudentUseCase(Get.find<StudentRepository>()), fenix: true);
    Get.lazyPut(() => WatchOnlineUseCase(Get.find<NetworkStatusRepository>()), fenix: true);
    Get.lazyPut(
      () => HomeController(
        Get.find<GetSubjectsUseCase>(),
        Get.find<GetContinueLessonUseCase>(),
        Get.find<WatchStudentUseCase>(),
        Get.find<WatchOnlineUseCase>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => GetLastOpenedLessonUseCase(Get.find<ContinueLessonRepository>()), fenix: true);
    Get.lazyPut(() => SubjectController(
          Get.find<GetSubjectDetailUseCase>(),
          Get.find<GetLastOpenedLessonUseCase>(),
          Get.find<WatchStudentUseCase>(),
        ));
  }
}
