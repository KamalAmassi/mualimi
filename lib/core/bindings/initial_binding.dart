import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../services/app_paths_service.dart';
import '../services/connectivity_service.dart';
import '../services/database_service.dart';
import '../services/device_capability_service.dart';
import '../services/device_info_source.dart';
import '../services/model_runtime.dart';
import '../services/settings_service.dart';
import '../services/tutor_engine_service.dart';

/// Registers every permanent service. Services need async setup, so [create]
/// initializes them in dependency order before the app starts, and
/// [dependencies] then puts the ready instances into GetX.
class InitialBinding extends Bindings {
  InitialBinding._(
    this._paths,
    this._settings,
    this._device,
    this._connectivity,
    this._databases,
    this._engine,
    this._runtime,
  );

  final AppPathsService _paths;
  final SettingsService _settings;
  final DeviceCapabilityService _device;
  final ConnectivityService _connectivity;
  final DatabaseService _databases;
  final TutorEngineService _engine;
  final ModelRuntime? _runtime;

  SettingsService get settings => _settings;

  /// The optional parameters are test seams; production passes only [runtime].
  static Future<InitialBinding> create({
    ModelRuntime? runtime,
    Directory? rootOverride,
    Connectivity? connectivityPlugin,
    DeviceInfoSource? deviceInfo,
  }) async {
    final paths = await AppPathsService(rootOverride: rootOverride).init();
    final settings = await SettingsService(paths.settingsFile).init();
    final device = await DeviceCapabilityService(source: deviceInfo).init();
    final connectivity = await ConnectivityService(connectivity: connectivityPlugin).init();
    final databases = await DatabaseService(paths).init();
    final engine = await TutorEngineService(
      paths: paths,
      settings: settings,
      device: device,
      runtime: runtime,
    ).init();
    return InitialBinding._(paths, settings, device, connectivity, databases, engine, runtime);
  }

  @override
  void dependencies() {
    Get.put(_paths, permanent: true);
    Get.put(_settings, permanent: true);
    Get.put(_device, permanent: true);
    Get.put(_connectivity, permanent: true);
    Get.put(_databases, permanent: true);
    Get.put(_engine, permanent: true);
    final runtime = _runtime;
    if (runtime != null) Get.put<ModelRuntime>(runtime, permanent: true);
  }
}
