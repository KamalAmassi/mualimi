import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/domain/entities/section_inline.dart';
import 'package:mualimi/features/lesson/domain/section_body/section_inline_parser.dart';

List<SectionInline> _parse(String line) => const SectionInlineParser().parse(line);

void main() {
  test('plain text is one run', () {
    expect(_parse('plain words'), [const TextInline('plain words')]);
  });

  test('empty line has no runs', () {
    expect(_parse(''), isEmpty);
  });

  test('bold runs split the text, also when glued to a letter', () {
    expect(_parse('a **b** c'), [
      const TextInline('a '),
      const TextInline('b', bold: true),
      const TextInline(' c'),
    ]);
    expect(_parse('x**y**'), [const TextInline('x'), const TextInline('y', bold: true)]);
  });

  test('inline math keeps its source', () {
    expect(_parse(r'force $F = k \frac{q}{r^2}$ here'), [
      const TextInline('force '),
      const MathInline(r'F = k \frac{q}{r^2}'),
      const TextInline(' here'),
    ]);
  });

  test('math inside bold is bold math', () {
    expect(_parse(r'**is $x$**'), [
      const TextInline('is ', bold: true),
      const MathInline('x', bold: true),
    ]);
  });

  test('an escaped dollar is a literal dollar', () {
    expect(_parse(r'costs \$5 and \$6'), [const TextInline(r'costs $5 and $6')]);
    expect(_parse(r'$a \$ b$'), [const MathInline(r'a \$ b')]);
  });

  test('an unclosed bold marker stays literal', () {
    expect(_parse('a **b c'), [const TextInline('a **b c')]);
  });

  test('an unclosed dollar stays literal', () {
    expect(_parse(r'price $5 only'), [const TextInline(r'price $5 only')]);
  });

  test('empty pairs stay literal', () {
    expect(_parse('a **** b'), [const TextInline('a **** b')]);
    expect(_parse(r'a $$ b'), [const TextInline(r'a $$ b')]);
    expect(_parse(r'a $ $ b'), [const TextInline(r'a $ $ b')]);
  });

  test('Arabic text around math keeps its order', () {
    final arabic = String.fromCharCodes([0x0642, 0x0648, 0x0629]);
    expect(_parse('$arabic \$F\$ $arabic'), [
      TextInline('$arabic '),
      const MathInline('F'),
      TextInline(' $arabic'),
    ]);
  });
}
