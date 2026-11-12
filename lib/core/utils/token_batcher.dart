import 'dart:async';

import '../constants/limits.dart';

/// Collects streamed tokens and hands them over in batches every
/// [Limits.streamFlushMs], so the UI rebuilds ~20 times a second instead of
/// once per token.
class TokenBatcher {
  TokenBatcher(this._onFlush, {Duration? interval})
      : _interval = interval ?? const Duration(milliseconds: Limits.streamFlushMs);

  final void Function(String batch) _onFlush;
  final Duration _interval;
  final _buffer = StringBuffer();
  Timer? _timer;

  void add(String token) {
    _buffer.write(token);
    _timer ??= Timer(_interval, flush);
  }

  /// Emits whatever is pending now (call when the stream ends or stops).
  void flush() {
    _timer?.cancel();
    _timer = null;
    if (_buffer.isEmpty) return;
    final batch = _buffer.toString();
    _buffer.clear();
    _onFlush(batch);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _buffer.clear();
  }
}
