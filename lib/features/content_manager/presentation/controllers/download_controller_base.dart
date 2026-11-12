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

  Future<void> start() async {
    if (connectivity.isOnMobile && !_mobileApproved) {
      ui.value = DownloadUiState.awaitingNetworkChoice;
      return;
    }
    if (!connectivity.isOnline) {
      _fail(const NetworkFailure('offline'));
      return;
    }
    await _begin();
  }

  /// Local-file imports don't need a network, so they skip the checks in [start].
  Future<void> startOffline() => _begin();

  Future<void> _begin() async {
    final params = await buildParams();
    if (params == null) {
      ui.value = DownloadUiState.failed;
      return;
    }
    failure.value = null;
    ui.value = DownloadUiState.downloading;
    await _subscription?.cancel();
    _subscription = _download(params).listen(_apply);
  }

  void continueOnMobile() {
    _mobileApproved = true;
    start();
  }

  void waitForWifi() {
    ui.value = DownloadUiState.waitingForWifi;
    _wifiWatcher?.dispose();
    _wifiWatcher = ever(connectivity.network, (_) {
      if (connectivity.isOnWifi) {
        _wifiWatcher?.dispose();
        start();
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
    switch (p.phase) {
      case DownloadPhase.downloading:
        ui.value = DownloadUiState.downloading;
      case DownloadPhase.paused:
        ui.value = DownloadUiState.paused;
      case DownloadPhase.verifying:
        ui.value = DownloadUiState.verifying;
      case DownloadPhase.assembling:
        ui.value = DownloadUiState.assembling;
      case DownloadPhase.canceled:
        ui.value = DownloadUiState.idle;
      case DownloadPhase.failed:
        _fail(p.failure ?? const NetworkFailure());
      case DownloadPhase.completed:
        ui.value = DownloadUiState.completed;
        onCompleted();
    }
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
