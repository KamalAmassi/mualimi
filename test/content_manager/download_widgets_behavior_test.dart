import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_dimens.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_action_button.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_hero_card.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_icon.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_icons.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_bars.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_icon.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_row.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

import 'download_widgets_harness.dart';

BoxDecoration _iconDecoration(WidgetTester tester) => tester
    .widget<Container>(find.descendant(of: find.byType(DownloadStepIcon), matching: find.byType(Container)).first)
    .decoration! as BoxDecoration;

Color? _textColor(WidgetTester tester, String text) => tester.widget<Text>(find.text(text)).style?.color;

void main() {
  const c = AppColors.light;

  group('step icon / row states', () {
    Future<void> pumpRow(WidgetTester tester, DownloadStepState state) =>
        pumpDownloadWidget(tester, DownloadStepRow(state: state, title: 'T', subtitle: 'S'));

    testWidgets('done: success circle with check', (tester) async {
      await pumpRow(tester, DownloadStepState.done);
      expect(_iconDecoration(tester).color, c.success);
      final icon = tester.widget<DownloadIcon>(find.byType(DownloadIcon));
      expect((icon.path, icon.color), (DownloadIcons.check, c.onPrimary));
      expect((_textColor(tester, 'T'), _textColor(tester, 'S')), (c.textPrimary, c.textSecondary));
    });

    testWidgets('error: error circle with X and error subtitle', (tester) async {
      await pumpRow(tester, DownloadStepState.error);
      expect(_iconDecoration(tester).color, c.error);
      expect(tester.widget<DownloadIcon>(find.byType(DownloadIcon)).path, DownloadIcons.close);
      expect((_textColor(tester, 'T'), _textColor(tester, 'S')), (c.textPrimary, c.error));
    });

    testWidgets('active: 3px primaryText ring with inner dot', (tester) async {
      await pumpRow(tester, DownloadStepState.active);
      final border = _iconDecoration(tester).border! as Border;
      expect((border.top.color, border.top.width), (c.primaryText, DownloadDimens.stepActiveRingWidth));
      expect(find.byType(DownloadIcon), findsNothing);
      final dot = tester
          .widgetList<Container>(find.descendant(of: find.byType(DownloadStepIcon), matching: find.byType(Container)))
          .last;
      expect((dot.decoration! as BoxDecoration).color, c.primaryText);
    });

    testWidgets('pending: 2px outline ring and secondary title', (tester) async {
      await pumpRow(tester, DownloadStepState.pending);
      final border = _iconDecoration(tester).border! as Border;
      expect((border.top.color, border.top.width), (c.outline, DownloadDimens.stepPendingRingWidth));
      expect(_textColor(tester, 'T'), c.textSecondary);
    });
  });

  group('hero card', () {
    for (final p in [0, 62, 100]) {
      testWidgets('shows $p and fills ${p / 100}', (tester) async {
        await pumpDownloadWidget(
          tester,
          DownloadHeroCard(title: 'T', subtitle: 'S', percent: p, progress: p / 100),
        );
        expect(find.textContaining('$p', findRichText: true), findsOneWidget);
        final bar = tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox));
        expect(bar.widthFactor, closeTo(p / 100, 1e-9));
      });
    }

    testWidgets('progress is clamped to 0..1', (tester) async {
      await pumpDownloadWidget(tester, const DownloadHeroCard(title: 'T', subtitle: 'S', percent: 1, progress: 3));
      expect(tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox)).widthFactor, 1);
    });
  });

  group('action button', () {
    ButtonStyle style(WidgetTester tester) => tester.widget<TextButton>(find.byType(TextButton)).style!;

    testWidgets('filled: fires when enabled, primary bg, radius 14', (tester) async {
      var taps = 0;
      await pumpDownloadWidget(
        tester,
        DownloadActionButton(label: 'L', iconPath: DownloadIcons.refresh, onPressed: () => taps++),
      );
      await tester.tap(find.text('L'));
      expect(taps, 1);
      final s = style(tester);
      expect(s.backgroundColor!.resolve({}), c.primary);
      expect((s.shape!.resolve({})! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(DownloadDimens.filledButtonRadius));
      expect(s.side!.resolve({}), BorderSide.none);
    });

    testWidgets('outlined: surface bg, 1.5 outline border, radius 16', (tester) async {
      await pumpDownloadWidget(
        tester,
        DownloadActionButton(label: 'L', variant: DownloadButtonVariant.outlined, onPressed: () {}),
      );
      final s = style(tester);
      expect(s.backgroundColor!.resolve({}), c.surface);
      expect(s.side!.resolve({}), BorderSide(color: c.outline, width: DownloadDimens.outlinedButtonBorderWidth));
      expect((s.shape!.resolve({})! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(DownloadDimens.outlinedButtonRadius));
    });

    testWidgets('disabled: no callback, muted colours', (tester) async {
      await pumpDownloadWidget(tester, const DownloadActionButton(label: 'L', onPressed: null));
      await tester.tap(find.text('L'), warnIfMissed: false);
      expect(tester.widget<TextButton>(find.byType(TextButton)).enabled, isFalse);
      expect(style(tester).foregroundColor!.resolve({}), c.textSecondary);
    });

    testWidgets('dark theme uses dark tokens', (tester) async {
      await pumpDownloadWidget(tester, DownloadActionButton(label: 'L', onPressed: () {}), theme: AppTheme.dark);
      expect(style(tester).backgroundColor!.resolve({}), AppColors.dark.primary);
    });
  });

  testWidgets('step bars: 3 primary bars 14/14/28', (tester) async {
    await pumpDownloadWidget(tester, const DownloadStepBars());
    final bars = tester.widgetList<Container>(
      find.descendant(of: find.byType(DownloadStepBars), matching: find.byType(Container)),
    );
    expect(bars.length, 3);
    final sizes = [for (final b in bars) tester.getSize(find.byWidget(b))];
    expect(sizes.map((s) => s.width), [14, 14, 28]);
    expect(sizes.every((s) => s.height == 6), isTrue);
    expect(bars.every((b) => (b.decoration! as BoxDecoration).color == c.primary), isTrue);
  });
}
