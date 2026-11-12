import 'package:get/get.dart';

import '../constants/limits.dart';
import 'device_info_source.dart';
import 'device_snapshot.dart';
import 'device_tier.dart';

class DeviceCapabilityService extends GetxService {
  DeviceCapabilityService({DeviceInfoSource? source})
      : _source = source ?? DeviceInfoPlusSource();

  final DeviceInfoSource _source;
  DeviceSnapshot _snapshot = const DeviceSnapshot();

  Future<DeviceCapabilityService> init() async {
    _snapshot = await _source.read();
    return this;
  }

  /// Unknown RAM is treated as capable: we only downgrade on proof.
  DeviceTier get tier {
    final ram = _snapshot.ramBytes;
    return ram != null && ram < Limits.minRamBytesForModel
        ? DeviceTier.searchOnly
        : DeviceTier.full;
  }

  /// Null when the platform can't report free space.
  int? get freeSpaceBytes => _snapshot.freeDiskBytes;

  Future<int?> refreshFreeSpace() async {
    _snapshot = await _source.read();
    return freeSpaceBytes;
  }
}
