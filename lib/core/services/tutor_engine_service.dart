import 'package:get/get.dart';

import '../constants/tutor_config.dart';
import 'connectivity_service.dart';

enum TutorEngineState { ready, offline, notConfigured }

/// Tells every tutor screen whether the cloud tutor can be reached right now.
class TutorEngineService extends GetxService {
  TutorEngineService(this._connectivity, {bool? isConfigured})
      : isConfigured = isConfigured ?? TutorConfig.isConfigured {
    state = _read().obs;
    _worker = ever(_connectivity.network, (_) => state.value = _read());
  }

  final ConnectivityService _connectivity;
  final bool isConfigured;
  late final Rx<TutorEngineState> state;
  late final Worker _worker;

  TutorEngineState _read() {
    if (!isConfigured) return TutorEngineState.notConfigured;
    return _connectivity.isOnline
        ? TutorEngineState.ready
        : TutorEngineState.offline;
  }

  @override
  void onClose() {
    _worker.dispose();
    super.onClose();
  }
}
