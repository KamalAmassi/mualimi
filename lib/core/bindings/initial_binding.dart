import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../db/content/seed/dev_seed_loader.dart';
import '../services/app_paths_service.dart';
import '../services/connectivity_service.dart';
import '../services/database_service.dart';
import '../services/device_capability_service.dart';
import '../services/device_info_source.dart';
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
  );

  final AppPathsService _paths;
  final SettingsService _settings;
  final DeviceCapabilityService _device;
  final ConnectivityService _connectivity;
  final DatabaseService _databases;
  final TutorEngineService _engine;

  SettingsService get settings => _settings;

  /// The optional parameters are test seams; [installDevSeed] is for debug builds.
  static Future<InitialBinding> create({
    Directory? rootOverride,
    Connectivity? connectivityPlugin,
    DeviceInfoSource? deviceInfo,
    bool installDevSeed = false,
  }) async {
    final paths = await AppPathsService(rootOverride: rootOverride).init();
    final settings = await SettingsService(paths.settingsFile).init();
    final device = await DeviceCapabilityService(source: deviceInfo).init();
    final connectivity =
        await ConnectivityService(connectivity: connectivityPlugin).init();
    final databases = await DatabaseService(paths).init();
    if (installDevSeed) {
      await DevSeedLoader.installIfMissing(paths, settings, databases);
    }
    final engine = TutorEngineService(connectivity);
    return InitialBinding._(
        paths, settings, device, connectivity, databases, engine);
  }

  @override
  void dependencies() {
    Get.put(_paths, permanent: true);
    Get.put(_settings, permanent: true);
    Get.put(_device, permanent: true);
    Get.put(_connectivity, permanent: true);
    Get.put(_databases, permanent: true);
    Get.put(_engine, permanent: true);
  }
}
