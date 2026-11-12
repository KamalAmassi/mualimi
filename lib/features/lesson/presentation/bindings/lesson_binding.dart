import 'package:get/get.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/database_service.dart';
import '../../data/datasources/lesson_local_data_source.dart';
import '../../data/datasources/lesson_progress_local_data_source.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/usecases/get_book_solutions_usecase.dart';
import '../../domain/usecases/get_key_terms_usecase.dart';
import '../../domain/usecases/get_last_section_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/save_lesson_progress_usecase.dart';
import '../controllers/key_terms_controller.dart';
import '../controllers/lesson_controller.dart';
import '../controllers/viewer_controller.dart';

/// Shared by /lesson/:id, /key-terms/:lessonId and /viewer/:lessonId.
class LessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonRepository>(() {
      final databases = Get.find<DatabaseService>();
      return LessonRepositoryImpl(
        LessonLocalDataSource(databases),
        LessonProgressLocalDataSource(databases.user),
      );
    }, fenix: true);
    Get.lazyPut(() => GetLessonUseCase(Get.find<LessonRepository>()), fenix: true);
    Get.lazyPut(() => GetKeyTermsUseCase(Get.find<LessonRepository>()), fenix: true);
    Get.lazyPut(() => GetBookSolutionsUseCase(Get.find<LessonRepository>()), fenix: true);
    Get.lazyPut(() => GetLastSectionUseCase(Get.find<LessonRepository>()), fenix: true);
    Get.lazyPut(() => SaveLessonProgressUseCase(Get.find<LessonRepository>()), fenix: true);

    Get.lazyPut(() => LessonController(
          Get.find<GetLessonUseCase>(),
          Get.find<GetLastSectionUseCase>(),
          Get.find<SaveLessonProgressUseCase>(),
          Get.find<ConnectivityService>(),
        ));
    Get.lazyPut(() => KeyTermsController(Get.find<GetKeyTermsUseCase>()));
    Get.lazyPut(() => ViewerController(
          Get.find<GetLessonUseCase>(),
          Get.find<GetBookSolutionsUseCase>(),
        ));
  }
}
