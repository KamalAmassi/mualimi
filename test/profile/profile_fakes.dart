import 'dart:async';

import 'package:mualimi/features/profile/domain/entities/app_theme_mode.dart';
import 'package:mualimi/features/profile/domain/entities/pack_update_check.dart';
import 'package:mualimi/features/profile/domain/entities/profile.dart';
import 'package:mualimi/features/profile/domain/entities/storage_usage.dart';
import 'package:mualimi/features/profile/domain/repositories/pack_update_repository.dart';
import 'package:mualimi/features/profile/domain/repositories/profile_repository.dart';
import 'package:mualimi/features/profile/domain/repositories/storage_usage_repository.dart';
import 'package:mualimi/features/profile/domain/usecases/change_grade_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/check_pack_status_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/cycle_font_scale_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/get_storage_usage_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/set_theme_mode_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/update_student_name_usecase.dart';
import 'package:mualimi/features/profile/domain/usecases/watch_profile_usecase.dart';
import 'package:mualimi/features/profile/presentation/controllers/profile_controller.dart';

const profileAhmad = Profile(
  name: 'أحمد',
  grade: 9,
  themeMode: AppThemeMode.light,
  fontScale: 1.0,
  packVersion: 3,
);

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this.profile);

  Profile profile;
  final _changes = StreamController<Profile>.broadcast();

  void emit(Profile next) {
    profile = next;
    _changes.add(next);
  }

  Profile _with({String? name, int? grade, AppThemeMode? themeMode, double? fontScale}) =>
      Profile(
        name: name ?? profile.name,
        grade: grade ?? profile.grade,
        themeMode: themeMode ?? profile.themeMode,
        fontScale: fontScale ?? profile.fontScale,
        packVersion: profile.packVersion,
      );

  @override
  Profile getProfile() => profile;

  @override
  Stream<Profile> watchProfile() async* {
    yield profile;
    yield* _changes.stream;
  }

  @override
  Future<void> updateName(String name) async => emit(_with(name: name));

  @override
  Future<void> changeGrade(int grade) async => emit(_with(grade: grade));

  @override
  Future<void> setThemeMode(AppThemeMode mode) async => emit(_with(themeMode: mode));

  @override
  Future<void> setFontScale(double scale) async => emit(_with(fontScale: scale));
}

class FakeStorageUsageRepository implements StorageUsageRepository {
  FakeStorageUsageRepository(this.usage);
  StorageUsage usage;
  int calls = 0;

  @override
  Future<StorageUsage> getUsage() async {
    calls++;
    return usage;
  }
}

class FakePackUpdateRepository implements PackUpdateRepository {
  FakePackUpdateRepository(this.result);
  PackUpdateCheck result;
  final checkedGrades = <int>[];

  @override
  Future<PackUpdateCheck> check(int grade) async {
    checkedGrades.add(grade);
    return result;
  }
}

class ProfileFixture {
  ProfileFixture({
    Profile profile = profileAhmad,
    StorageUsage usage = const StorageUsage(packBytes: 30 << 20, pdfBytes: 10 << 20),
    PackUpdateCheck updateResult = PackUpdateCheck.upToDate,
  })  : profiles = FakeProfileRepository(profile),
        storage = FakeStorageUsageRepository(usage),
        updates = FakePackUpdateRepository(updateResult);

  final FakeProfileRepository profiles;
  final FakeStorageUsageRepository storage;
  final FakePackUpdateRepository updates;
  int updateSheetOpens = 0;

  ProfileController controller() => ProfileController(
        GetProfileUseCase(profiles),
        UpdateStudentNameUseCase(profiles),
        ChangeGradeUseCase(profiles),
        SetThemeModeUseCase(profiles),
        watchProfile: WatchProfileUseCase(profiles),
        cycleFontScale: CycleFontScaleUseCase(profiles),
        getStorageUsage: GetStorageUsageUseCase(storage),
        checkPackStatus: CheckPackStatusUseCase(updates),
        openPackUpdate: () async => updateSheetOpens++,
      );
}
