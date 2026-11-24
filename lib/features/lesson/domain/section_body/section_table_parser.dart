import '../entities/section_block.dart';
import '../entities/section_inline.dart';
import 'section_inline_parser.dart';

/// Reads a GitHub-style table: a header row, a `|---|` separator, then rows.
class SectionTableParser {
  const SectionTableParser(this._inline);

  final SectionInlineParser _inline;

  static final _separatorCell = RegExp(r'^:?-+:?$');

  /// The table starting at [start] and the index after it, or null when
  /// [start] does not open a table.
  (TableBlock, int)? parse(List<String> lines, int start) {
    if (start + 1 >= lines.length) return null;
    final headerLine = lines[start].trim();
    if (!headerLine.contains('|') || !_isSeparator(lines[start + 1])) return null;

    final header = _cells(headerLine);
    final rows = <List<List<SectionInline>>>[];
    var i = start + 2;
    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.isEmpty || !line.contains('|')) break;
      rows.add(_fitted(_cells(line), header.length));
      i++;
    }
    return (TableBlock(header: header, rows: rows), i);
  }

  bool _isSeparator(String line) {
    final trimmed = line.trim();
    if (!trimmed.contains('-')) return false;
    return _rawCells(trimmed).every((cell) => _separatorCell.hasMatch(cell));
  }

  List<List<SectionInline>> _cells(String line) =>
      [for (final cell in _rawCells(line)) _inline.parse(cell)];

  List<String> _rawCells(String line) {
    var inner = line;
    if (inner.startsWith('|')) inner = inner.substring(1);
    if (inner.endsWith('|')) inner = inner.substring(0, inner.length - 1);
    return [for (final cell in inner.split('|')) cell.trim()];
  }

  List<List<SectionInline>> _fitted(List<List<SectionInline>> cells, int count) => [
        for (var c = 0; c < count; c++) c < cells.length ? cells[c] : const <SectionInline>[],
      ];
}
