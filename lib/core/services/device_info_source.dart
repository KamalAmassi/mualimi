import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'device_snapshot.dart';

abstract class DeviceInfoSource {
  Future<DeviceSnapshot> read();
}

class DeviceInfoPlusSource implements DeviceInfoSource {
  static const _bytesPerMb = 1024 * 1024;

  @override
  Future<DeviceSnapshot> read() async {
    // Only Android reports RAM and free disk through device_info_plus.
    if (!Platform.isAndroid) return const DeviceSnapshot();
    final info = await DeviceInfoPlugin().androidInfo;
    return DeviceSnapshot(
      ramBytes: info.physicalRamSize * _bytesPerMb,
      freeDiskBytes: info.freeDiskSize,
    );
  }
}
