import 'tutor_engine_state.dart';

typedef _K = TutorEngineKind;

/// The only place that defines which state changes are legal.
abstract final class TutorEngineTransitions {
  static const Map<_K, Set<_K>> _allowed = {
    _K.notDownloaded: {_K.downloading, _K.verifying, _K.downloaded, _K.unsupported},
    _K.downloading: {_K.paused, _K.verifying, _K.notDownloaded},
    _K.paused: {_K.downloading, _K.notDownloaded},
    // verifying → downloading: a corrupt part is re-downloaded alone.
    // verifying → downloaded: single-file import or final full-file check passed.
    _K.verifying: {_K.assembling, _K.downloading, _K.downloaded},
    _K.assembling: {_K.verifying, _K.downloaded},
    _K.downloaded: {_K.loading, _K.notDownloaded},
    _K.loading: {_K.ready, _K.downloaded},
    _K.ready: {_K.downloaded, _K.notDownloaded},
    // Retry paths out of failure.
    _K.failed: {_K.notDownloaded, _K.downloading, _K.verifying, _K.downloaded},
    _K.unsupported: {_K.searchOnly},
    _K.searchOnly: {},
  };

  /// Any state may fail; failure is never reached from itself.
  static bool isAllowed(TutorEngineState from, TutorEngineState to) {
    if (to.kind == _K.failed) return from.kind != _K.failed;
    // Progress ticks stay inside `downloading`.
    if (from.kind == _K.downloading && to.kind == _K.downloading) return true;
    return _allowed[from.kind]!.contains(to.kind);
  }
}
