import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'network_kind.dart';

class ConnectivityService extends GetxService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final network = NetworkKind.offline.obs;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool get isOnline => network.value != NetworkKind.offline;
  bool get isOnWifi => network.value == NetworkKind.wifi;
  bool get isOnMobile => network.value == NetworkKind.mobile;

  Future<ConnectivityService> init() async {
    network.value = _map(await _connectivity.checkConnectivity());
    _sub = _connectivity.onConnectivityChanged.listen((r) => network.value = _map(r));
    return this;
  }

  // Wi-Fi/ethernet win over mobile when several links are up.
  static NetworkKind _map(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      return NetworkKind.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) return NetworkKind.mobile;
    return NetworkKind.offline;
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
