class TextRun {
  const TextRun(this.text, {this.bold = false});
  final String text;
  final bool bold;
}

/// One paragraph of an answer; [number] is set for numbered points.
class AnswerBlock {
  const AnswerBlock(this.runs, {this.number});
  final List<TextRun> runs;
  final String? number;
}

/// Splits answer text into paragraphs and numbered points, and reads
/// `**bold**` markers.
abstract final class AnswerTextParser {
  static final _numbered = RegExp(r'^\s*([0-9٠-٩]+)\s*[.)\-]\s+(.*)$');
  static final _bold = RegExp(r'\*\*(.+?)\*\*');

  static List<AnswerBlock> parse(String text) {
    final blocks = <AnswerBlock>[];
    for (final line in text.split('\n')) {
      if (line.trim().isEmpty) continue;
      final match = _numbered.firstMatch(line);
      blocks.add(match == null
          ? AnswerBlock(_runs(line.trim()))
          : AnswerBlock(_runs(match.group(2)!), number: match.group(1)));
    }
    return blocks;
  }

  static List<TextRun> _runs(String line) {
    final runs = <TextRun>[];
    var last = 0;
    for (final m in _bold.allMatches(line)) {
      if (m.start > last) runs.add(TextRun(line.substring(last, m.start)));
      runs.add(TextRun(m.group(1)!, bold: true));
      last = m.end;
    }
    if (last < line.length) runs.add(TextRun(line.substring(last)));
    return runs;
  }
}
