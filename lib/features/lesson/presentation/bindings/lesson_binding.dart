import 'package:get/get.dart';

import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../data/datasources/lesson_local_data_source.dart';
import '../../data/datasources/lesson_progress_local_data_source.dart';
import '../../data/datasources/subject_tutor_local_data_source.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../data/repositories/pack_image_repository_impl.dart';
import '../../data/repositories/reading_preferences_repository_impl.dart';
import '../../data/repositories/subject_tutor_repository_impl.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/repositories/pack_image_repository.dart';
import '../../domain/repositories/reading_preferences_repository.dart';
import '../../domain/repositories/subject_tutor_repository.dart';
import '../../domain/usecases/get_book_solutions_usecase.dart';
import '../../domain/usecases/get_font_scale_usecase.dart';
import '../../domain/usecases/get_key_terms_usecase.dart';
import '../../domain/usecases/get_last_section_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../../domain/usecases/get_pack_image_path_usecase.dart';
import '../../domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import '../../domain/usecases/parse_section_body_usecase.dart';
import '../../domain/usecases/save_font_scale_usecase.dart';
import '../../domain/usecases/save_lesson_progress_usecase.dart';
import '../controllers/key_terms_controller.dart';
import '../controllers/lesson_controller.dart';
import '../controllers/section_body_controller.dart';
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
    Get.lazyPut<ReadingPreferencesRepository>(
        () => ReadingPreferencesRepositoryImpl(Get.find<SettingsService>()),
        fenix: true);
    Get.lazyPut<SubjectTutorRepository>(
        () => SubjectTutorRepositoryImpl(SubjectTutorLocalDataSource(Get.find<DatabaseService>())),
        fenix: true);
    Get.lazyPut(() => GetFontScaleUseCase(Get.find<ReadingPreferencesRepository>()), fenix: true);
    Get.lazyPut(() => SaveFontScaleUseCase(Get.find<ReadingPreferencesRepository>()), fenix: true);
    Get.lazyPut(() => IsLessonTutorEnabledUseCase(Get.find<SubjectTutorRepository>()), fenix: true);
    Get.lazyPut<PackImageRepository>(
        () => PackImageRepositoryImpl(Get.find<AppPathsService>()),
        fenix: true);
    Get.lazyPut(() => const ParseSectionBodyUseCase(), fenix: true);
    Get.lazyPut(() => GetPackImagePathUseCase(Get.find<PackImageRepository>()), fenix: true);

    Get.lazyPut(() => LessonController(
          Get.find<GetLessonUseCase>(),
          Get.find<GetKeyTermsUseCase>(),
          Get.find<IsLessonTutorEnabledUseCase>(),
        ));
    Get.lazyPut(() => KeyTermsController(
          Get.find<GetKeyTermsUseCase>(),
          Get.find<GetLessonUseCase>(),
        ));
    Get.lazyPut(() => ViewerController(
          Get.find<GetLessonUseCase>(),
          Get.find<GetBookSolutionsUseCase>(),
          Get.find<GetLastSectionUseCase>(),
          Get.find<SaveLessonProgressUseCase>(),
          Get.find<GetFontScaleUseCase>(),
          Get.find<SaveFontScaleUseCase>(),
          Get.find<IsLessonTutorEnabledUseCase>(),
        ));
    Get.lazyPut(
        () => SectionBodyController(
              Get.find<ParseSectionBodyUseCase>(),
              Get.find<GetPackImagePathUseCase>(),
            ),
        fenix: true);
  }
}
