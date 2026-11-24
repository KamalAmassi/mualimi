import '../entities/callout_kind.dart';
import '../entities/section_block.dart';
import 'section_inline_parser.dart';
import 'section_table_parser.dart';

/// Parses a `sections.body` written in the Markdown subset of
/// `docs/pack-format.md`. Anything outside the subset becomes paragraph text;
/// the parser never throws.
class SectionBodyParser {
  const SectionBodyParser();

  static const _inline = SectionInlineParser();
  static const _table = SectionTableParser(_inline);
  static const _displayMath = r'$$';
  static const _bullet = '- ';
  static const _quote = '>';
  static final _heading = RegExp(r'^(#{2,3})\s+(\S.*)$');
  static final _image = RegExp(r'^!\[([^\]]*)\]\(([^()\s]+)\)$');

  List<SectionBlock> parse(String body) {
    final lines = body.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');
    final blocks = <SectionBlock>[];
    final paragraph = <String>[];

    void flushParagraph() {
      if (paragraph.isEmpty) return;
      blocks.add(ParagraphBlock(_inline.parse(paragraph.join(' '))));
      paragraph.clear();
    }

    var i = 0;
    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        flushParagraph();
        i++;
        continue;
      }
      final block = _block(lines, i);
      if (block == null) {
        paragraph.add(line);
        i++;
        continue;
      }
      flushParagraph();
      blocks.add(block.$1);
      i = block.$2;
    }
    flushParagraph();
    return blocks;
  }

  /// The block opened by the line at [i] and the index after it, or null when
  /// that line is paragraph text.
  (SectionBlock, int)? _block(List<String> lines, int i) {
    final line = lines[i].trim();
    final heading = _heading.firstMatch(line);
    if (heading != null) {
      return (HeadingBlock(heading.group(1)!.length, _inline.parse(heading.group(2)!)), i + 1);
    }
    final image = _image.firstMatch(line);
    if (image != null) {
      return (ImageBlock(caption: image.group(1)!.trim(), path: image.group(2)!), i + 1);
    }
    if (line.startsWith(_displayMath)) return _mathBlock(lines, i);
    if (line.startsWith(_bullet)) return _bulletList(lines, i);
    if (line.startsWith(_quote)) return _callout(lines, i);
    return _table.parse(lines, i);
  }

  (SectionBlock, int)? _mathBlock(List<String> lines, int i) {
    final line = lines[i].trim();
    if (line != _displayMath) {
      final closed = line.length > 2 * _displayMath.length && line.endsWith(_displayMath);
      if (!closed) return null;
      final tex = line.substring(_displayMath.length, line.length - _displayMath.length).trim();
      return tex.isEmpty ? null : (DisplayMathBlock(tex), i + 1);
    }
    for (var end = i + 1; end < lines.length; end++) {
      if (lines[end].trim() != _displayMath) continue;
      final tex = lines.sublist(i + 1, end).map((l) => l.trim()).join('\n').trim();
      return tex.isEmpty ? null : (DisplayMathBlock(tex), end + 1);
    }
    return null;
  }

  (SectionBlock, int) _bulletList(List<String> lines, int i) {
    final items = [
      for (; i < lines.length && lines[i].trim().startsWith(_bullet); i++)
        _inline.parse(lines[i].trim().substring(_bullet.length).trim()),
    ];
    return (BulletListBlock(items), i);
  }

  (SectionBlock, int)? _callout(List<String> lines, int i) {
    final text = <String>[];
    var end = i;
    for (; end < lines.length && lines[end].trim().startsWith(_quote); end++) {
      final content = lines[end].trim().substring(_quote.length).trim();
      if (content.isNotEmpty) text.add(content);
    }
    final joined = text.join(' ');
    for (final kind in CalloutKind.values) {
      if (joined.startsWith('**${kind.marker}**')) {
        return (CalloutBlock(kind, _inline.parse(joined)), end);
      }
    }
    return null;
  }
}
