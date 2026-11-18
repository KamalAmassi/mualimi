import 'dart:async';

import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../content_manager/presentation/constants/grade_ordinals.dart';
import '../../../lesson/domain/entities/reading_font_scale.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/pack_update_check.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/storage_usage.dart';
import '../../domain/usecases/change_grade_usecase.dart';
import '../../domain/usecases/check_pack_status_usecase.dart';
import '../../domain/usecases/cycle_font_scale_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_storage_usage_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import '../../domain/usecases/update_student_name_usecase.dart';
import '../../domain/usecases/watch_profile_usecase.dart';
import '../widgets/profile_strings.dart';

class ProfileController extends GetxController {
  ProfileController(
    this._getProfile,
    this._updateName,
    this._changeGrade,
    this._setThemeMode, {
    required WatchProfileUseCase watchProfile,
    required CycleFontScaleUseCase cycleFontScale,
    required GetStorageUsageUseCase getStorageUsage,
    required CheckPackStatusUseCase checkPackStatus,
    required Future<void> Function() openPackUpdate,
  })  : _watchProfile = watchProfile,
        _cycleFontScale = cycleFontScale,
        _getStorageUsage = getStorageUsage,
        _checkPackStatus = checkPackStatus,
        _openPackUpdate = openPackUpdate;

  final GetProfileUseCase _getProfile;
  final UpdateStudentNameUseCase _updateName;
  final ChangeGradeUseCase _changeGrade;
  final SetThemeModeUseCase _setThemeMode;
  final WatchProfileUseCase _watchProfile;
  final CycleFontScaleUseCase _cycleFontScale;
  final GetStorageUsageUseCase _getStorageUsage;
  final CheckPackStatusUseCase _checkPackStatus;
  final Future<void> Function() _openPackUpdate;

  static const _fontLabels = [
    ProfileStrings.fontMedium,
    ProfileStrings.fontLarge,
    ProfileStrings.fontExtraLarge,
  ];

  late final profile = _getProfile().obs;
  final nameInvalid = false.obs;
  final storage = Rxn<StorageUsage>();
  final checkingUpdate = false.obs;

  /// True only after an online check found nothing newer for the installed pack.
  final upToDate = false.obs;

  StreamSubscription<Profile>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _watchProfile().listen(_onProfile);
    loadStorage();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _onProfile(Profile next) {
    final previous = profile.value;
    profile.value = next;
    if (next.packVersion != previous.packVersion || next.grade != previous.grade) {
      upToDate.value = false;
      loadStorage();
    }
  }

  void _refresh() => profile.value = _getProfile();

  Future<void> loadStorage() async => storage.value = await _getStorageUsage();

  String get initial => current.name.isEmpty ? '' : current.name.characters.first;

  String get gradeOrdinal => current.grade == null ? '' : GradeOrdinals.of(current.grade!);

  String get headerSubtitle => current.grade == null
      ? ProfileStrings.noAccount
      : '${ProfileStrings.grade} $gradeOrdinal${ProfileStrings.separator}${ProfileStrings.noAccount}';

  String get fontScaleLabel {
    final steps = ReadingFontScale.steps;
    var nearest = 0;
    for (var i = 1; i < steps.length; i++) {
      if ((steps[i] - current.fontScale).abs() < (steps[nearest] - current.fontScale).abs()) {
        nearest = i;
      }
    }
    return _fontLabels[nearest];
  }

  String get packSubtitle {
    final version = current.packVersion;
    if (version == null) return '';
    final label = ProfileStrings.version(version);
    return upToDate.value ? '$label${ProfileStrings.separator}${ProfileStrings.upToDate}' : label;
  }

  /// Returns whether the sheet can close.
  Future<bool> saveName(String name) async {
    final saved = await _updateName(name);
    nameInvalid.value = !saved;
    if (saved) _refresh();
    return saved;
  }

  /// A new grade needs its own content pack, so we go straight to the download.
  Future<void> changeGrade(int grade) async {
    await _changeGrade(grade);
    _refresh();
    Get.toNamed<void>(AppRoutes.download);
  }

  Future<void> setTheme(AppThemeMode mode) async {
    await _setThemeMode(mode);
    _refresh();
  }

  Future<void> cycleFontScale() async {
    await _cycleFontScale();
    _refresh();
  }

  Future<void> checkForUpdate() async {
    if (checkingUpdate.value) return;
    checkingUpdate.value = true;
    try {
      final result = await _checkPackStatus(current.grade);
      upToDate.value = result == PackUpdateCheck.upToDate;
      if (result == PackUpdateCheck.updateAvailable) await _openPackUpdate();
    } finally {
      checkingUpdate.value = false;
    }
  }

  Profile get current => profile.value;
}