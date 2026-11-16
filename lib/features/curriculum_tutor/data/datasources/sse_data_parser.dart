/// Incremental parser for a server-sent-events body. Feed it text as it
/// arrives; it returns the `data` payload of every event completed so far.
class SseDataParser {
  final _pendingLine = StringBuffer();
  final _data = <String>[];

  List<String> add(String chunk) {
    final events = <String>[];
    final text = '$_pendingLine$chunk';
    _pendingLine.clear();
    final lines = text.split('\n');
    // The last element is an unfinished line (or empty after a final newline).
    _pendingLine.write(lines.removeLast());
    for (var line in lines) {
      if (line.endsWith('\r')) line = line.substring(0, line.length - 1);
      if (line.isEmpty) {
        if (_data.isNotEmpty) events.add(_data.join('\n'));
        _data.clear();
      } else if (line.startsWith('data:')) {
        _data.add(line.substring(5).trimLeft());
      }
    }
    return events;
  }

  /// Flushes an event the server left without a closing blank line.
  List<String> close() {
    final tail = _pendingLine.toString();
    _pendingLine.clear();
    if (tail.startsWith('data:')) _data.add(tail.substring(5).trimLeft());
    if (_data.isEmpty) return const [];
    final event = _data.join('\n');
    _data.clear();
    return [event];
  }
}
