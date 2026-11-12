/// Raw hardware numbers; `null` means the platform can't report them.
class DeviceSnapshot {
  const DeviceSnapshot({this.ramBytes, this.freeDiskBytes});

  final int? ramBytes;
  final int? freeDiskBytes;
}
