import 'dart:async';

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
        fontScale: _settings.fontScale.value,
        packVersion: _settings.installedPackVersion.value,
      );

  @override
  Stream<Profile> watchProfile() {
    late final StreamController<Profile> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    controller = StreamController<Profile>(
      onListen: () {
        controller.add(getProfile());
        void emit(Object? _) => controller.add(getProfile());
        subscriptions
          ..add(_settings.studentName.listen(emit))
          ..add(_settings.grade.listen(emit))
          ..add(_settings.themeMode.listen(emit))
          ..add(_settings.fontScale.listen(emit))
          ..add(_settings.installedPackVersion.listen(emit));
      },
      onCancel: () => Future.wait(subscriptions.map((s) => s.cancel())),
    );
    return controller.stream;
  }

  @override
  Future<void> updateName(String name) => _settings.setStudentName(name);

  @override
  Future<void> changeGrade(int grade) => _settings.setGrade(grade);

  @override
  Future<void> setThemeMode(AppThemeMode mode) => _settings.setThemeMode(_toFlutter[mode]!);

  @override
  Future<void> setFontScale(double scale) => _settings.setFontScale(scale);
}