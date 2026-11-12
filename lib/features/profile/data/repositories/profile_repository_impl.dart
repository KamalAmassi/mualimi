import 'package:flutter/material.dart';

import '../../../../core/services/settings_service.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._settings);
  final SettingsService _settings;

  static const _toFlutter = {
    AppThemeMode.system: ThemeMode.system,
    AppThemeMode.light: ThemeMode.light,
    AppThemeMode.dark: ThemeMode.dark,
  };

  @override
  Profile getProfile() => Profile(
        name: _settings.studentName.value,
        grade: _settings.grade.value,
        themeMode: _toFlutter.entries.firstWhere((e) => e.value == _settings.themeMode.value).key,
      );

  @override
  Future<void> updateName(String name) => _settings.setStudentName(name);

  @override
  Future<void> changeGrade(int grade) => _settings.setGrade(grade);

  @override
  Future<void> setThemeMode(AppThemeMode mode) => _settings.setThemeMode(_toFlutter[mode]!);
}
