import 'package:get/get.dart';

import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/device_capability_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../data/datasources/artifact_downloader.dart';
import '../../data/datasources/background_part_downloader.dart';
import '../../data/datasources/download_state_local_data_source.dart';
import '../../data/datasources/local_file_model_source.dart';
import '../../data/datasources/manifest_local_data_source.dart';
import '../../data/datasources/manifest_remote_data_source.dart';
import '../../data/datasources/network_model_source.dart';
import '../../data/datasources/pack_installer.dart';
import '../../data/repositories/artifact_repository_impl.dart';
import '../../data/repositories/installed_content_repository_impl.dart';
import '../../data/repositories/manifest_repository_impl.dart';
import '../../data/repositories/storage_repository_impl.dart';
import '../../domain/entities/model_source_kind.dart';
import '../../domain/repositories/artifact_repository.dart';
import '../../domain/repositories/installed_content_repository.dart';
import '../../domain/repositories/manifest_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/usecases/cancel_download_usecase.dart';
import '../../domain/usecases/check_pack_update_usecase.dart';
import '../../domain/usecases/download_artifacts_usecase.dart';
import '../../domain/usecases/get_manifest_usecase.dart';
import '../../domain/usecases/pause_download_usecase.dart';
import '../../domain/usecases/resume_download_usecase.dart';

/// Wiring for everything in content_manager except its controllers.
/// Repositories are `fenix` so they survive route changes mid-download.
class ContentManagerBinding extends Bindings {
  @override
  void dependencies() {
    final paths = Get.find<AppPathsService>();
    final databases = Get.find<DatabaseService>();
    final settings = Get.find<SettingsService>();

    Get.lazyPut<ManifestRepository>(
      () => ManifestRepositoryImpl(
        HttpManifestRemoteDataSource(),
        ManifestLocalDataSource(paths.manifestCacheFile),
      ),
      fenix: true,
    );
    Get.lazyPut<StorageRepository>(
      () => StorageRepositoryImpl(Get.find<DeviceCapabilityService>()),
      fenix: true,
    );
    Get.lazyPut<InstalledContentRepository>(
      () => InstalledContentRepositoryImpl(settings, databases),
      fenix: true,
    );
    Get.lazyPut<ArtifactRepository>(
      () {
        final downloader = ArtifactDownloader(BackgroundPartDownloader());
        return ArtifactRepositoryImpl(
          paths: paths,
          settings: settings,
          installer: PackInstaller(paths, databases, settings),
          states: DownloadStateLocalDataSource(databases.user),
          sourceFor: (kind, localPath) => kind == ModelSourceKind.localFile
              ? LocalFileModelSource(localPath!)
              : NetworkModelSource(downloader),
        );
      },
      fenix: true,
    );

    Get.lazyPut(() => GetManifestUseCase(Get.find<ManifestRepository>()), fenix: true);
    Get.lazyPut(
      () => CheckPackUpdateUseCase(
          Get.find<ManifestRepository>(), Get.find<InstalledContentRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DownloadArtifactsUseCase(
          Get.find<ArtifactRepository>(), Get.find<StorageRepository>()),
      fenix: true,
    );
    Get.lazyPut(() => PauseDownloadUseCase(Get.find<ArtifactRepository>()), fenix: true);
    Get.lazyPut(() => ResumeDownloadUseCase(Get.find<ArtifactRepository>()), fenix: true);
    Get.lazyPut(() => CancelDownloadUseCase(Get.find<ArtifactRepository>()), fenix: true);
  }
}
