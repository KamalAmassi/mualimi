import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/lesson/domain/entities/callout_kind.dart';
import 'package:mualimi/features/lesson/domain/section_body/section_body_parser.dart';
import 'package:mualimi/features/lesson/presentation/widgets/section_body_dimens.dart';
import 'package:mualimi/features/lesson/presentation/widgets/section_body_view.dart';
import 'package:mualimi/features/lesson/presentation/widgets/viewer_dimens.dart';

Future<void> _pump(WidgetTester tester, String body,
    {double fontScale = 1, String? Function(String)? imagePathOf}) async {
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.light,
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SectionBodyView(
            blocks: const SectionBodyParser().parse(body),
            fontScale: fontScale,
            imagePathOf: imagePathOf ?? (_) => null,
          ),
        ),
      ),
    ),
  ));
}

TextStyle _style(WidgetTester tester, String text) => tester.widget<Text>(find.text(text)).style!;

TextSpan _span(WidgetTester tester, String paragraph, String run) {
  final root = tester.widget<Text>(find.text(paragraph)).textSpan!;
  late TextSpan found;
  root.visitChildren((span) {
    if (span is TextSpan && span.text == run) found = span;
    return true;
  });
  return found;
}

void main() {
  final colors = AppColors.light;

  for (final scale in [1.0, 1.3]) {
    testWidgets('headings and paragraphs use the design sizes times $scale', (tester) async {
      await _pump(tester, '## Two\n\n### Three\n\nplain **bold** end', fontScale: scale);
      expect(_style(tester, 'Two').fontSize, closeTo(ViewerDimens.headingSize * scale, 0.001));
      expect(_style(tester, 'Two').color, colors.primary);
      expect(
          _style(tester, 'Three').fontSize, closeTo(SectionBodyDimens.heading3Size * scale, 0.001));
      expect(_style(tester, 'Three').color, colors.textPrimary);
      final body = _style(tester, 'plain bold end');
      expect(body.fontSize, closeTo(ViewerDimens.bodySize * scale, 0.001));
      expect(body.height, ViewerDimens.bodyLineHeight);
      expect(body.color, colors.textPrimary);
      expect(_span(tester, 'plain bold end', 'bold').style!.fontWeight, FontWeight.w700);
    });

    testWidgets('display and inline math render left to right at $scale', (tester) async {
      await _pump(tester, 'force \$F\$ here\n\n\$\$a = b\$\$', fontScale: scale);
      final maths = tester.widgetList<Math>(find.byType(Math)).toList();
      expect(maths, hasLength(2));
      expect(maths[0].mathStyle, MathStyle.text);
      expect(maths[0].textStyle!.fontSize, closeTo(ViewerDimens.bodySize * scale, 0.001));
      expect(maths[1].mathStyle, MathStyle.display);
      expect(
          maths[1].textStyle!.fontSize, closeTo(SectionBodyDimens.displayMathSize * scale, 0.001));
      for (final math in find.byType(Math).evaluate()) {
        expect(Directionality.of(math), TextDirection.ltr);
      }
    });
  }

  testWidgets('bullets show one glyph per item in the body style', (tester) async {
    await _pump(tester, '- one\n- two');
    expect(find.text(SectionBodyDimens.bulletGlyph), findsNWidgets(2));
    expect(_style(tester, 'two').fontSize, ViewerDimens.bodySize);
  });

  for (final (kind, container, accent, text) in [
    (CalloutKind.remember, colors.infoContainer, colors.info, colors.onInfoContainer),
    (CalloutKind.warning, colors.warningContainer, colors.warning, colors.onWarningContainer),
  ]) {
    testWidgets('the ${kind.name} callout uses its colour tokens', (tester) async {
      await _pump(tester, '> **${kind.marker}** note', fontScale: 1.3);
      final label = '${kind.marker} note';
      expect(_style(tester, label).color, text);
      expect(
          _style(tester, label).fontSize, closeTo(SectionBodyDimens.calloutTextSize * 1.3, 0.001));
      expect(_span(tester, label, kind.marker).style!.fontWeight, FontWeight.w700);
      expect(tester.widget<Icon>(find.byType(Icon)).color, accent);
      final box = tester.widget<DecoratedBox>(
          find.ancestor(of: find.byType(Icon), matching: find.byType(DecoratedBox)).first);
      expect((box.decoration as BoxDecoration).color, container);
    });
  }

  testWidgets('a formula that does not parse shows its source', (tester) async {
    await _pump(tester, r'$$\frac{1$$');
    expect(tester.takeException(), isNull);
    expect(find.text(r'\frac{1'), findsOneWidget);
    expect(_style(tester, r'\frac{1').color, colors.textSecondary);
  });

  testWidgets('a table has a tinted bold header and scrolls sideways', (tester) async {
    await _pump(tester, '| h1 | h2 |\n|---|---|\n| a | b |');
    final table = tester.widget<Table>(find.byType(Table));
    expect((table.children.first.decoration as BoxDecoration).color, colors.surfaceVariant);
    expect(_style(tester, 'h1').fontWeight, FontWeight.w700);
    expect(_style(tester, 'a').fontWeight, isNot(FontWeight.w700));
    final scroll =
        find.ancestor(of: find.byType(Table), matching: find.byType(SingleChildScrollView));
    expect(tester.widget<SingleChildScrollView>(scroll.first).scrollDirection, Axis.horizontal);
  });

  testWidgets('an image outside the pack shows its caption only', (tester) async {
    await _pump(tester, '![The caption](images/a.webp)');
    expect(find.byType(Image), findsNothing);
    expect(_style(tester, 'The caption').color, colors.textSecondary);
  });

  testWidgets('an image without a caption and without a file shows nothing', (tester) async {
    await _pump(tester, '![](images/a.webp)\n\nafter');
    expect(find.byType(Image), findsNothing);
    expect(find.text('after'), findsOneWidget);
  });

  testWidgets('a missing pack image file falls back to its caption', (tester) async {
    final requested = <String>[];
    await _pump(tester, '![The caption](images/a.webp)', imagePathOf: (path) {
      requested.add(path);
      return 'missing/a.webp';
    });
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
    expect(requested, ['images/a.webp']);
    expect(tester.takeException(), isNull);
    expect(find.text('The caption'), findsOneWidget);
  });
}
