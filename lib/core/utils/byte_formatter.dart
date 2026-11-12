abstract final class ByteFormatter {
  static const _kb = 1024;
  static const _units = ['بايت', 'ك.ب', 'م.ب', 'غ.ب'];

  /// Binary units (1024), one decimal for MB and above.
  static String format(int bytes) {
    var value = bytes.toDouble();
    var unit = 0;
    while (value >= _kb && unit < _units.length - 1) {
      value /= _kb;
      unit++;
    }
    final text = unit < 2 ? value.round().toString() : value.toStringAsFixed(1);
    return '$text ${_units[unit]}';
  }
}
