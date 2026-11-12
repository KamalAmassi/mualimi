import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/storage_keys.dart';

/// Student preferences, persisted as a small JSON file in internal storage.
class SettingsService extends GetxService {
  SettingsService(this._file);

  final File _file;
  Map<String, dynamic> _data = {};

  final studentName = ''.obs;
  final grade = RxnInt();
  final themeMode = ThemeMode.system.obs;
  final fontScale = 1.0.obs;
  final onboardingDone = false.obs;
  final installedPackVersion = RxnInt();
  final installedModelFile = RxnString();
  final installedEmbeddingFile = RxnString();

  Future<SettingsService> init() async {
    if (await _file.exists()) {
      try {
        _data = jsonDecode(await _file.readAsString()) as Map<String, dynamic>;
      } on FormatException {
        _data = {}; // corrupt file: fall back to defaults
      }
    }
    studentName.value = _data[StorageKeys.studentName] as String? ?? '';
    grade.value = _data[StorageKeys.grade] as int?;
    themeMode.value = ThemeMode.values.firstWhere(
      (m) => m.name == _data[StorageKeys.themeMode],
      orElse: () => ThemeMode.system,
    );
    fontScale.value = (_data[StorageKeys.fontScale] as num?)?.toDouble() ?? 1.0;
    onboardingDone.value = _data[StorageKeys.onboardingDone] as bool? ?? false;
    installedPackVersion.value = _data[StorageKeys.installedPackVersion] as int?;
    installedModelFile.value = _data[StorageKeys.installedModelFile] as String?;
    installedEmbeddingFile.value = _data[StorageKeys.installedEmbeddingFile] as String?;
    return this;
  }

  Future<void> setStudentName(String v) => _set(StorageKeys.studentName, v, studentName);
  Future<void> setGrade(int v) => _set(StorageKeys.grade, v, grade);
  Future<void> setFontScale(double v) => _set(StorageKeys.fontScale, v, fontScale);
  Future<void> setOnboardingDone(bool v) =>
      _set(StorageKeys.onboardingDone, v, onboardingDone);
  Future<void> setInstalledPackVersion(int? v) =>
      _set(StorageKeys.installedPackVersion, v, installedPackVersion);
  Future<void> setInstalledModelFile(String? v) =>
      _set(StorageKeys.installedModelFile, v, installedModelFile);
  Future<void> setInstalledEmbeddingFile(String? v) =>
      _set(StorageKeys.installedEmbeddingFile, v, installedEmbeddingFile);

  Future<void> setThemeMode(ThemeMode v) async {
    themeMode.value = v;
    await _persist(StorageKeys.themeMode, v.name);
  }

  Future<void> _set<T>(String key, T? value, Rx<T?> rx) async {
    rx.value = value;
    await _persist(key, value);
  }

  Future<void> _persist(String key, Object? value) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
    await _file.writeAsString(jsonEncode(_data));
  }
}
