import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_action_button.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_banner.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_hero_card.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_icons.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_scaffold.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_status_header.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_bars.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_list.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_row.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

import 'download_widgets_harness.dart';

const _long = 'نص تجريبي طويل يكفي لاختبار الالتفاف على أكثر من سطر واحد في الشاشة';

Widget _steps() => const DownloadStepList(steps: [
      DownloadStepRow(state: DownloadStepState.done, title: 'أ', subtitle: _long),
      DownloadStepRow(state: DownloadStepState.active, title: 'ب', subtitle: 'ب'),
      DownloadStepRow(state: DownloadStepState.pending, title: _long),
      DownloadStepRow(state: DownloadStepState.error, title: 'د', subtitle: 'د'),
    ]);

Widget _hero() => const DownloadHeroCard(
      title: _long,
      subtitle: _long,
      percent: 62,
      progress: 0.62,
      sideText: 'نص جانبي',
    );

final Map<String, Widget Function()> _standalone = {
  'step bars': () => const DownloadStepBars(),
  'filled button': () => DownloadActionButton(label: _long, iconPath: DownloadIcons.refresh, onPressed: () {}),
  'outlined button': () => const DownloadActionButton(
        label: 'إيقاف',
        iconPath: DownloadIcons.pause,
        variant: DownloadButtonVariant.outlined,
        onPressed: null,
      ),
  'step list': _steps,
  'hero card': _hero,
  'hero card muted': () => const DownloadHeroCard(
        title: 'أ',
        subtitle: 'ب',
        percent: 100,
        progress: 1,
        fill: DownloadHeroFill.muted,
      ),
  'success banner': () => const DownloadBanner(
        variant: DownloadBannerVariant.success,
        iconPath: DownloadIcons.refresh,
        lead: 'عنوان',
        body: _long,
      ),
  'warning banner': () => const DownloadBanner(
        variant: DownloadBannerVariant.warning,
        iconPath: DownloadIcons.wifiOff,
        title: 'عنوان',
        body: _long,
      ),
  'status header': () => const DownloadStatusHeader(
        variant: DownloadStatusVariant.error,
        iconPath: DownloadIcons.phone,
        title: _long,
        body: _long,
      ),
};

void main() {
  for (final (name, theme, scale) in downloadRenderMatrix) {
    group('$name theme @ $scale', () {
      for (final entry in _standalone.entries) {
        testWidgets('${entry.key} renders without overflow', (tester) async {
          await pumpDownloadWidget(tester, entry.value(), theme: theme, textScale: scale);
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('scaffold with full content renders without overflow', (tester) async {
        await pumpDownloadWidget(
          tester,
          DownloadScaffold(
            title: _long,
            onBack: () {},
            footer: [
              const DownloadStepBars(),
              DownloadActionButton(label: 'زر', iconPath: DownloadIcons.download, onPressed: () {}),
            ],
            children: [_hero(), _steps()],
          ),
          theme: theme,
          textScale: scale,
          framed: true,
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(DownloadStepBars), findsOneWidget);
      });
    });
  }
}
