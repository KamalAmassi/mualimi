import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/network_kind.dart';
import 'download_timings.dart';
import 'download_ui_state.dart';
import 'pause_reason.dart';

/// The connectivity rules of a download. It remembers why the download is
/// paused and whether mobile data was approved, and reacts to the network:
/// - offline mid-download → paused with reason = network;
/// - Wi-Fi → mobile mid-download without approval → paused + mobile prompt;
/// - network back (stable for the debounce) → resume, or start if no job.
/// A user pause is never resumed here.
class NetworkResumePolicy {
  NetworkResumePolicy(
    this._connectivity, {
    required Rx<DownloadUiState> ui,
    required Rxn<Failure> failure,
    required bool Function() jobAlive,
    required Future<bool> Function() pauseJob,
    required Future<bool> Function() resumeJob,
    required Future<void> Function() beginJob,
    Duration debounce = DownloadTimings.networkDebounce,
  })  : _ui = ui,
        _failure = failure,
        _jobAlive = jobAlive,
        _pauseJob = pauseJob,
        _resumeJob = resumeJob,
        _beginJob = beginJob,
        _debounce = debounce;

  final ConnectivityService _connectivity;
  final Rx<DownloadUiState> _ui;
  final Rxn<Failure> _failure;
  final bool Function() _jobAlive;
  final Future<bool> Function() _pauseJob;
  final Future<bool> Function() _resumeJob;
  final Future<void> Function() _beginJob;
  final Duration _debounce;
  Worker? _worker;
  Timer? _timer;
  bool _mobileApproved = false;
  PauseReason? _reason;

  /// Null while the download isn't paused or waiting.
  PauseReason? get reason => _reason;

  bool get _needsMobileApproval => _connectivity.isOnMobile && !_mobileApproved;

  void listen() {
    _worker?.dispose();
    _worker = ever<NetworkKind>(_connectivity.network, _onChange);
  }

  void _onChange(NetworkKind kind) {
    _timer?.cancel();
    final state = _ui.value;
    if (kind == NetworkKind.offline) {
      final lostMidJob = state == DownloadUiState.downloading ||
          (state == DownloadUiState.failed && _failure.value is NetworkFailure);
      if (lostMidJob) _onLost();
      return;
    }
    // Back on Wi-Fi: a later switch to mobile data asks again.
    if (kind == NetworkKind.wifi) _mobileApproved = false;
    if (state == DownloadUiState.downloading && _needsMobileApproval) _askMobile();
    _timer = Timer(_debounce, () {
      if (_shouldResume(_ui.value)) proceed();
    });
  }

  bool _shouldResume(DownloadUiState state) {
    if (!_connectivity.isOnline) return false;
    if (state == DownloadUiState.waitingForWifi) return _connectivity.isOnWifi;
    return _reason == PauseReason.network &&
        (state == DownloadUiState.paused || state == DownloadUiState.awaitingNetworkChoice);
  }

  /// Continues once the network allows it: waits while offline, asks on
  /// unapproved mobile data, else resumes the job or starts a new one.
  Future<void> proceed() async {
    if (!_connectivity.isOnline) return _waitForNetwork();
    if (_needsMobileApproval) {
      _ui.value = DownloadUiState.awaitingNetworkChoice;
      return;
    }
    clear();
    if (!_jobAlive()) return _beginJob();
    if (await _resumeJob()) _ui.value = DownloadUiState.downloading;
  }

  void approveMobile() => _mobileApproved = true;

  Future<void> pauseByUser() async {
    clear();
    _reason = PauseReason.user;
    if (await _pauseJob()) {
      _ui.value = DownloadUiState.paused;
    } else {
      _reason = null;
    }
  }

  /// True when [f] was a network failure turned into a paused state.
  bool absorbs(Failure f) {
    if (f is! NetworkFailure) return false;
    if (_reason == PauseReason.user) return true; // stays paused for the user
    if (_connectivity.isOnline && _reason != PauseReason.network) return false;
    _waitForNetwork();
    return true;
  }

  /// Forgets the pause reason and any scheduled resume.
  void clear() {
    _reason = null;
    _timer?.cancel();
  }

  void _waitForNetwork() {
    _reason = PauseReason.network;
    _ui.value = DownloadUiState.paused;
  }

  void _onLost() {
    _waitForNetwork();
    if (_jobAlive()) unawaited(_pauseJob());
  }

  void _askMobile() {
    _reason = PauseReason.network;
    _ui.value = DownloadUiState.awaitingNetworkChoice;
    unawaited(_pauseJob());
  }

  void dispose() {
    _timer?.cancel();
    _worker?.dispose();
  }
}
