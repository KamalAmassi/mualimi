import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_lesson_bodies.dart';
import 'package:mualimi/features/lesson/domain/entities/callout_kind.dart';
import 'package:mualimi/features/lesson/domain/entities/section_block.dart';
import 'package:mualimi/features/lesson/domain/entities/section_inline.dart';
import 'package:mualimi/features/lesson/domain/section_body/section_body_parser.dart';

List<SectionBlock> _parse(String body) => const SectionBodyParser().parse(body);

ParagraphBlock _paragraph(String text) => ParagraphBlock([TextInline(text)]);

void main() {
  test('empty and blank bodies have no blocks', () {
    expect(_parse(''), isEmpty);
    expect(_parse('\n  \n\t\n'), isEmpty);
  });

  test('headings of level 2 and 3', () {
    expect(_parse('## Two\n### Three **b**'), [
      const HeadingBlock(2, [TextInline('Two')]),
      const HeadingBlock(3, [TextInline('Three '), TextInline('b', bold: true)]),
    ]);
  });

  test('lines of one paragraph join with a space; blank lines split paragraphs', () {
    expect(_parse('one\ntwo\n\nthree'), [_paragraph('one two'), _paragraph('three')]);
  });

  test('consecutive bullets form one list', () {
    expect(_parse('- a\n- **b**\n\n- c'), [
      const BulletListBlock([
        [TextInline('a')],
        [TextInline('b', bold: true)],
      ]),
      const BulletListBlock([
        [TextInline('c')],
      ]),
    ]);
  });

  test('callouts keep their bold marker and join continued lines', () {
    for (final kind in CalloutKind.values) {
      final marker = kind.marker;
      expect(_parse('> **$marker** first\n> second'), [
        CalloutBlock(kind, [TextInline(marker, bold: true), const TextInline(' first second')]),
      ]);
    }
  });

  test('a blockquote without a callout marker is paragraph text', () {
    expect(_parse('> just a quote'), [_paragraph('> just a quote')]);
  });

  test(r'display math on one line or between $$ lines', () {
    expect(_parse(r'$$x^2$$'), [const DisplayMathBlock('x^2')]);
    expect(_parse('\$\$\n  a = b\n  + c\n\$\$\nafter'), [
      const DisplayMathBlock('a = b\n+ c'),
      _paragraph('after'),
    ]);
  });

  test(r'an unclosed or empty $$ block is paragraph text', () {
    expect(_parse('\$\$\nx = 1'), [_paragraph(r'$$ x = 1')]);
    expect(_parse(r'$$ $$'), [_paragraph(r'$$ $$')]);
    expect(_parse('\$\$\n\$\$'), [_paragraph(r'$$ $$')]);
  });

  test('an image on its own line', () {
    expect(_parse('![A caption](images/a.webp)'),
        [const ImageBlock(caption: 'A caption', path: 'images/a.webp')]);
    expect(_parse('see ![x](images/a.webp) here'), [_paragraph('see ![x](images/a.webp) here')]);
  });

  test('a table pads short rows and drops extra cells', () {
    expect(_parse('| h1 | **h2** |\n|---|:--:|\n| a |\n| b | c | d |'), [
      const TableBlock(header: [
        [TextInline('h1')],
        [TextInline('h2', bold: true)],
      ], rows: [
        [
          [TextInline('a')],
          [],
        ],
        [
          [TextInline('b')],
          [TextInline('c')],
        ],
      ]),
    ]);
  });

  test('pipes without a separator row are paragraph text', () {
    expect(_parse('| a | b |\n| c | d |'), [_paragraph('| a | b | | c | d |')]);
  });

  test('syntax outside the subset is paragraph text', () {
    expect(_parse('# one'), [_paragraph('# one')]);
    expect(_parse('#### four'), [_paragraph('#### four')]);
    expect(_parse('1. first'), [_paragraph('1. first')]);
    expect(_parse('* star'), [_paragraph('* star')]);
    expect(_parse('##no space'), [_paragraph('##no space')]);
    expect(_parse('-'), [_paragraph('-')]);
  });

  test('Windows and old Mac line endings parse like Unix ones', () {
    const unix = '## T\n\n- a\n- b\n\ntext';
    expect(_parse(unix.replaceAll('\n', '\r\n')), _parse(unix));
    expect(_parse(unix.replaceAll('\n', '\r')), _parse(unix));
  });

  test('mixed content keeps the block order', () {
    final body = '## H\n\nintro \$x\$\n\n- item\n\n\$\$y\$\$\n\n'
        '> **${CalloutKind.warning.marker}** note\n\n| a |\n|---|\n| 1 |\n\n![c](images/c.webp)';
    expect(_parse(body).map((b) => b.runtimeType), [
      HeadingBlock,
      ParagraphBlock,
      BulletListBlock,
      DisplayMathBlock,
      CalloutBlock,
      TableBlock,
      ImageBlock,
    ]);
  });

  test('the development seed bodies use every block they are meant to show', () {
    final charging = _parse(chargingSections[0].$2);
    expect(charging.map((b) => b.runtimeType), [
      HeadingBlock,
      ParagraphBlock,
      HeadingBlock,
      BulletListBlock,
      CalloutBlock,
      CalloutBlock,
    ]);
    expect(charging.whereType<CalloutBlock>().map((c) => c.kind),
        [CalloutKind.remember, CalloutKind.warning]);

    final table = _parse(chargingSections[1].$2).last as TableBlock;
    expect(table.header, hasLength(3));
    expect(table.rows, hasLength(3));

    final force = _parse(forceSections[0].$2);
    expect(force.map((b) => b.runtimeType), [
      HeadingBlock,
      ParagraphBlock,
      DisplayMathBlock,
      ParagraphBlock,
      CalloutBlock,
    ]);
    expect((force[1] as ParagraphBlock).inlines, contains(const MathInline('F')));
    expect((force[3] as ParagraphBlock).inlines.whereType<MathInline>(), hasLength(1));
  });
}
