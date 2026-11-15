import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/pack_info.dart';
import '../../domain/usecases/check_pack_update_usecase.dart';
import '../../domain/usecases/download_params.dart';
import '../../domain/usecases/get_manifest_usecase.dart';
import 'download_controller_base.dart';

/// Downloads the grade's content pack: first-run onboarding (step 3/3) or an update.
class PackDownloadController extends DownloadControllerBase {
  PackDownloadController({
    required super.download,
    required super.pause,
    required super.resume,
    required super.cancel,
    required super.connectivity,
    required GetManifestUseCase getManifest,
    required CheckPackUpdateUseCase checkUpdate,
    required SettingsService settings,
    this.autoStart = false,
  })  : _getManifest = getManifest,
        _checkUpdate = checkUpdate,
        _settings = settings;

  final GetManifestUseCase _getManifest;
  final CheckPackUpdateUseCase _checkUpdate;
  final SettingsService _settings;

  /// The onboarding screen starts downloading as soon as it opens.
  final bool autoStart;

  /// Set when a newer pack is offered for the installed grade.
  final offeredPack = Rxn<PackInfo>();

  /// The grade the current (or last) job was started for.
  int? _jobGrade;
  Worker? _gradeWatcher;

  @override
  void onInit() {
    super.onInit();
    // An offer belongs to the grade it was checked for.
    _gradeWatcher = ever(_settings.grade, (_) => offeredPack.value = null);
  }

  @override
  void onReady() {
    super.onReady();
    if (autoStart) startForCurrentGrade();
  }

  /// What `/download` calls on entry, whether this controller is new or was
  /// registered earlier by the shell: download the pack of the grade selected
  /// now. A job already running for that grade is kept; one for another grade
  /// is canceled first.
  Future<void> startForCurrentGrade() async {
    final grade = _settings.grade.value;
    if (offeredPack.value?.grade != grade) offeredPack.value = null;
    if (isBusy && _jobGrade != grade) await cancel();
    await start();
  }

  @override
  Future<void> start() {
    if (!isBusy) _jobGrade = _settings.grade.value;
    return super.start();
  }

  Future<void> checkForUpdate() async {
    final grade = _settings.grade.value;
    if (grade == null) return;
    final result = await _checkUpdate(grade);
    offeredPack.value = result.fold((_) => null, (pack) => pack);
  }

  @override
  Future<DownloadParams?> buildParams() async {
    final grade = _settings.grade.value;
    final offered = offeredPack.value;
    if (offered != null && offered.grade == grade) return DownloadParams.pack(offered);

    if (grade == null) {
      failWith(const NotFoundFailure('no grade selected'));
      return null;
    }
    final result = await _getManifest(const NoParams());
    return result.fold(
      (f) {
        failWith(f);
        return null;
      },
      (manifest) {
        final pack = manifest.packFor(grade);
        if (pack == null) {
          failWith(const NotFoundFailure('no pack for this grade'));
          return null;
        }
        return DownloadParams.pack(pack);
      },
    );
  }

  @override
  Future<void> onCompleted() async {
    offeredPack.value = null;
    if (Get.isBottomSheetOpen ?? false) {
      Get.back<void>();
    } else if (Get.currentRoute == AppRoutes.download) {
      // First run or a grade change: either way the app is ready to use.
      await _settings.setOnboardingDone(true);
      Get.offAllNamed<void>(AppRoutes.shell);
    }
  }

  @override
  void onClose() {
    _gradeWatcher?.dispose();
    super.onClose();
  }
}
