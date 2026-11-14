import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../domain/entities/download_phase.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/usecases/cancel_download_usecase.dart';
import '../../domain/usecases/download_artifacts_usecase.dart';
import '../../domain/usecases/download_params.dart';
import '../../domain/usecases/pause_download_usecase.dart';
import '../../domain/usecases/resume_download_usecase.dart';
import 'download_phase_ui.dart';
import 'download_ui_state.dart';

/// The flow shared by pack and model downloads: mobile-data prompt, start,
/// pause/resume, cancel, and mapping progress events to UI state.
abstract class DownloadControllerBase extends GetxController {
  DownloadControllerBase({
    required DownloadArtifactsUseCase download,
    required PauseDownloadUseCase pause,
    required ResumeDownloadUseCase resume,
    required CancelDownloadUseCase cancel,
    required this.connectivity,
  })  : _download = download,
        _pause = pause,
        _resume = resume,
        _cancel = cancel;

  final DownloadArtifactsUseCase _download;
  final PauseDownloadUseCase _pause;
  final ResumeDownloadUseCase _resume;
  final CancelDownloadUseCase _cancel;
  final ConnectivityService connectivity;

  final ui = DownloadUiState.idle.obs;
  final progress = 0.0.obs;
  final bytesDone = 0.obs;
  final totalBytes = 0.obs;
  final failure = Rxn<Failure>();

  bool _mobileApproved = false;
  StreamSubscription<DownloadProgress>? _subscription;
  Worker? _wifiWatcher;

  /// Resolves what to download; null means it can't start (set [failure]).
  Future<DownloadParams?> buildParams();

  /// Called for every progress event, before UI state is updated.
  void onProgress(DownloadProgress p) {}

  Future<void> onCompleted();

  bool _starting = false;

  /// True while a job is being prepared, running, paused, or waiting on a
  /// network decision. [start] is a no-op then, so a job never runs twice.
  bool get isBusy => _starting || ui.value.isBusy;

  Future<void> start() async {
    if (isBusy) return;
    await _launch();
  }

  /// Local-file imports don't need a network, so they skip the checks in [start].
  Future<void> startOffline() async {
    if (isBusy) return;
    await _begin();
  }

  Future<void> _launch() async {
    if (connectivity.isOnMobile && !_mobileApproved) {
      ui.value = DownloadUiState.awaitingNetworkChoice;
      return;
    }
    if (!connectivity.isOnline) return _fail(const NetworkFailure('offline'));
    await _begin();
  }

  Future<void> _begin() async {
    if (_starting) return;
    _starting = true;
    try {
      final params = await buildParams();
      if (params == null) {
        ui.value = DownloadUiState.failed;
        return;
      }
      failure.value = null;
      ui.value = DownloadUiState.downloading;
      await _subscription?.cancel();
      _subscription = _download(params).listen(_apply);
    } finally {
      _starting = false;
    }
  }

  void continueOnMobile() {
    if (ui.value != DownloadUiState.awaitingNetworkChoice) return;
    _mobileApproved = true;
    _launch();
  }

  void waitForWifi() {
    ui.value = DownloadUiState.waitingForWifi;
    _wifiWatcher?.dispose();
    _wifiWatcher = ever(connectivity.network, (_) {
      if (connectivity.isOnWifi && ui.value == DownloadUiState.waitingForWifi) {
        _wifiWatcher?.dispose();
        _launch();
      }
    });
  }

  Future<void> pause() async {
    if (await _pause()) ui.value = DownloadUiState.paused;
  }

  Future<void> resume() async {
    if (await _resume()) ui.value = DownloadUiState.downloading;
  }

  Future<void> cancel() async {
    _wifiWatcher?.dispose();
    await _cancel();
    ui.value = DownloadUiState.idle;
  }

  void _apply(DownloadProgress p) {
    onProgress(p);
    bytesDone.value = p.bytesDone;
    totalBytes.value = p.totalBytes;
    progress.value = p.fraction;
    if (p.phase == DownloadPhase.failed) return _fail(p.failure ?? const NetworkFailure());
    ui.value = p.phase.uiState;
    if (p.phase == DownloadPhase.completed) onCompleted();
  }

  void _fail(Failure f) {
    failure.value = f;
    ui.value = f is NotEnoughSpaceFailure ? DownloadUiState.noSpace : DownloadUiState.failed;
  }

  /// For subclasses that fail before a stream exists.
  void failWith(Failure f) => _fail(f);

  @override
  void onClose() {
    _subscription?.cancel();
    _wifiWatcher?.dispose();
    super.onClose();
  }
}
