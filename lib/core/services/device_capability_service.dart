import 'package:get/get.dart';

import 'device_info_source.dart';
import 'device_snapshot.dart';

class DeviceCapabilityService extends GetxService {
  DeviceCapabilityService({DeviceInfoSource? source})
      : _source = source ?? DeviceInfoPlusSource();

  final DeviceInfoSource _source;
  DeviceSnapshot _snapshot = const DeviceSnapshot();

  Future<DeviceCapabilityService> init() async {
    _snapshot = await _source.read();
    return this;
  }

  /// Null when the platform can't report free space.
  int? get freeSpaceBytes => _snapshot.freeDiskBytes;

  Future<int?> refreshFreeSpace() async {
    _snapshot = await _source.read();
    return freeSpaceBytes;
  }
}
