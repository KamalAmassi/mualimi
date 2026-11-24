import '../entities/section_inline.dart';

/// Splits one line into text, `**bold**` and `$math$` runs.
///
/// A marker without a closing partner, or with only blanks between the pair, stays
/// as literal text. `\$` is a literal dollar sign.
class SectionInlineParser {
  const SectionInlineParser();

  static const _bold = '**';
  static const _dollar = r'$';
  static const _escapedDollar = r'\$';

  List<SectionInline> parse(String line) {
    final inlines = <SectionInline>[];
    final text = StringBuffer();
    var bold = false;

    void flushText() {
      if (text.isEmpty) return;
      inlines.add(TextInline(text.toString(), bold: bold));
      text.clear();
    }

    var i = 0;
    while (i < line.length) {
      if (line.startsWith(_escapedDollar, i)) {
        text.write(_dollar);
        i += _escapedDollar.length;
      } else if (line.startsWith(_bold, i)) {
        final start = i + _bold.length;
        if (bold || line.indexOf(_bold, start) > start) {
          flushText();
          bold = !bold;
        } else {
          text.write(_bold);
        }
        i = start;
      } else if (line.startsWith(_dollar, i)) {
        final close = _closingDollar(line, i + 1);
        final tex = close > i + 1 ? line.substring(i + 1, close) : '';
        if (tex.trim().isNotEmpty) {
          flushText();
          inlines.add(MathInline(tex, bold: bold));
          i = close + 1;
        } else {
          text.write(_dollar);
          i++;
        }
      } else {
        text.write(line[i]);
        i++;
      }
    }
    flushText();
    return inlines;
  }

  /// Index of the next unescaped `$` at or after [from], or -1.
  int _closingDollar(String line, int from) {
    var i = from;
    while (i < line.length) {
      if (line.startsWith(_escapedDollar, i)) {
        i += _escapedDollar.length;
      } else if (line.startsWith(_dollar, i)) {
        return i;
      } else {
        i++;
      }
    }
    return -1;
  }
}
