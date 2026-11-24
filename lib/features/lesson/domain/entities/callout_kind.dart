/// The two callouts a section body may contain, each opened by a bold marker.
enum CalloutKind {
  remember([0x062A, 0x0630, 0x0643, 0x0651, 0x0631, 0x003A]),
  warning([0x0627, 0x0646, 0x062A, 0x0628, 0x0647, 0x003A]);

  const CalloutKind(this._markerCodePoints);

  final List<int> _markerCodePoints;

  /// The marker text, without the surrounding `**`.
  String get marker => String.fromCharCodes(_markerCodePoints);
}
