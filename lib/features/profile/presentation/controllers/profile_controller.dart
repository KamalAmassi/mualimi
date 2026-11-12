import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/change_grade_usecase.dart';
import '../../domain/usecases/delete_model_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import '../../domain/usecases/update_student_name_usecase.dart';

class ProfileController extends GetxController {
  ProfileController(
    this._getProfile,
    this._updateName,
    this._changeGrade,
    this._setThemeMode,
    this._deleteModel,
  );

  final GetProfileUseCase _getProfile;
  final UpdateStudentNameUseCase _updateName;
  final ChangeGradeUseCase _changeGrade;
  final SetThemeModeUseCase _setThemeMode;
  final DeleteModelUseCase _deleteModel;

  late final profile = _getProfile().obs;
  final nameInvalid = false.obs;
  final deleteFailed = false.obs;

  void _refresh() => profile.value = _getProfile();

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

  Future<bool> deleteModel() async {
    final deleted = await _deleteModel();
    deleteFailed.value = !deleted;
    return deleted;
  }

  Profile get current => profile.value;
}
