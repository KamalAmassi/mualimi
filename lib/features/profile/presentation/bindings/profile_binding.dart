import 'package:get/get.dart';

import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../../content_manager/domain/usecases/check_pack_update_usecase.dart';
import '../../../content_manager/presentation/widgets/pack_update_sheet.dart';
import '../../data/datasources/storage_usage_local_data_source.dart';
import '../../data/repositories/pack_update_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/storage_usage_repository_impl.dart';
import '../../domain/repositories/pack_update_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/storage_usage_repository.dart';
import '../../domain/usecases/change_grade_usecase.dart';
import '../../domain/usecases/check_pack_status_usecase.dart';
import '../../domain/usecases/cycle_font_scale_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_storage_usage_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import '../../domain/usecases/update_student_name_usecase.dart';
import '../../domain/usecases/watch_profile_usecase.dart';
import '../controllers/profile_controller.dart';

/// Needs `ContentManagerShellBinding` first: the update check reuses its use case.
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(
        () => ProfileRepositoryImpl(Get.find<SettingsService>()), fenix: true);
    Get.lazyPut<StorageUsageRepository>(() {
      final paths = Get.find<AppPathsService>();
      return StorageUsageRepositoryImpl(StorageUsageLocalDataSource(
        contentDbPath: paths.contentDbFile.path,
        pdfDirPath: paths.pdfDir.path,
      ));
    }, fenix: true);
    Get.lazyPut<PackUpdateRepository>(
      () => PackUpdateRepositoryImpl(
          Get.find<ConnectivityService>(), Get.find<CheckPackUpdateUseCase>()),
      fenix: true,
    );
    Get.lazyPut(() => GetProfileUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => WatchProfileUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => UpdateStudentNameUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => ChangeGradeUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => SetThemeModeUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => CycleFontScaleUseCase(Get.find<ProfileRepository>()), fenix: true);
    Get.lazyPut(() => GetStorageUsageUseCase(Get.find<StorageUsageRepository>()), fenix: true);
    Get.lazyPut(() => CheckPackStatusUseCase(Get.find<PackUpdateRepository>()), fenix: true);
    Get.lazyPut(
      () => ProfileController(
        Get.find<GetProfileUseCase>(),
        Get.find<UpdateStudentNameUseCase>(),
        Get.find<ChangeGradeUseCase>(),
        Get.find<SetThemeModeUseCase>(),
        watchProfile: Get.find<WatchProfileUseCase>(),
        cycleFontScale: Get.find<CycleFontScaleUseCase>(),
        getStorageUsage: Get.find<GetStorageUsageUseCase>(),
        checkPackStatus: Get.find<CheckPackStatusUseCase>(),
        openPackUpdate: showPackUpdateSheetIfAvailable,
      ),
      fenix: true,
    );
  }
}