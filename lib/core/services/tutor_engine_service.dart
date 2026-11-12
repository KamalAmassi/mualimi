import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

import 'app_paths_service.dart';
import 'device_capability_service.dart';
import 'device_tier.dart';
import 'model_runtime.dart';
import 'settings_service.dart';
import 'tutor_engine_state.dart';
import 'tutor_engine_transitions.dart';

/// Single source of truth for the model's lifecycle. Every tutor screen
/// reads [state]; the downloader and the runtime drive it.
class TutorEngineService extends GetxService {
  TutorEngineService({
    required AppPathsService paths,
    required SettingsService settings,
    required DeviceCapabilityService device,
    ModelRuntime? runtime,
  })  : _paths = paths,
        _settings = settings,
        _device = device,
        _runtime = runtime;

  final AppPathsService _paths;
  final SettingsService _settings;
  final DeviceCapabilityService _device;
  final ModelRuntime? _runtime;

  final Rx<TutorEngineState> state = Rx<TutorEngineState>(const NotDownloaded());
  Future<void>? _loadInFlight;

  Future<TutorEngineService> init() async {
    if (_device.tier == DeviceTier.searchOnly) {
      transitionTo(const Unsupported());
      transitionTo(const SearchOnly());
    } else if (_installedModelFile?.existsSync() ?? false) {
      transitionTo(const Downloaded());
    }
    return this;
  }

  File? get _installedModelFile {
    final name = _settings.installedModelFile.value;
    return name == null ? null : _paths.modelFile(name);
  }

  /// Applies [next] if the state machine allows it; returns whether it did.
  bool transitionTo(TutorEngineState next) {
    if (!TutorEngineTransitions.isAllowed(state.value, next)) return false;
    state.value = next;
    return true;
  }

  void updateProgress(double progress, int bytes) {
    if (state.value is Downloading) {
      state.value = Downloading(progress: progress, bytes: bytes);
    }
  }

  /// Loads the model into RAM. Called only when the student opens the tutor
  /// or taps "Ask the tutor", never at startup. Concurrent calls share one load.
  Future<void> ensureLoaded() {
    if (state.value is Ready) return Future.value();
    return _loadInFlight ??= _load().whenComplete(() => _loadInFlight = null);
  }

  Future<void> _load() async {
    final file = _installedModelFile;
    final runtime = _runtime;
    if (file == null || runtime == null || !transitionTo(const Loading())) return;
    try {
      await runtime.load(file.path);
      transitionTo(const Ready());
    } catch (e) {
      transitionTo(Failed(e.toString()));
    }
  }

  /// Completes true when the model is ready, false if it can't become ready.
  /// Questions asked while loading wait here and are sent automatically.
  Future<bool> whenReady() async {
    if (state.value is Ready) return true;
    if (state.value is! Loading && state.value is! Downloaded) return false;
    if (state.value is Downloaded) unawaited(ensureLoaded());
    final completer = Completer<bool>();
    late final Worker worker;
    worker = ever<TutorEngineState>(state, (s) {
      if (s is Ready) {
        completer.complete(true);
      } else if (s is! Loading && s is! Downloaded) {
        completer.complete(false);
      }
      if (completer.isCompleted) worker.dispose();
    });
    return completer.future;
  }

  /// Frees RAM without deleting the file.
  Future<void> unload() async {
    if (state.value is! Ready) return;
    await _runtime?.unload();
    transitionTo(const Downloaded());
  }

  /// Deletes the model file and returns to `notDownloaded`. Never touches
  /// user.db. Returns false (deleting nothing) if the model is
  /// mid-verify or mid-load.
  Future<bool> deleteModel() async {
    if (state.value is Ready) await unload();
    final from = state.value;
    if (!TutorEngineTransitions.isAllowed(from, const NotDownloaded())) return false;
    final file = _installedModelFile;
    if (file != null && file.existsSync()) await file.delete();
    await _settings.setInstalledModelFile(null);
    return transitionTo(const NotDownloaded());
  }
}
