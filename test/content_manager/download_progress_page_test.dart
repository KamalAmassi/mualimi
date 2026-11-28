import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/constants/grade_ordinals.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_page.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_progress_page.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_action_button.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_hero_bar.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_hero_card.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_info_note.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_row.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

import '../helpers/pack_download_fakes.dart';
import 'download_widgets_harness.dart';

const _done = DownloadStepState.done;
const _active = DownloadStepState.active;
const _pending = DownloadStepState.pending;

void main() {
  late PackDownloadHarness h;
  late PackDownloadController c;

  setUp(() {
    h = PackDownloadHarness();
    c = Get.put(h.build(autoStart: false));
  });

  tearDown(() {
    h.download.closeAll();
    Get.reset();
  });

  Future<void> emit(WidgetTester tester, DownloadPhase phase, int done) async {
    h.download.emit(DownloadProgress(phase: phase, bytesDone: done, totalBytes: 100));
    // One pump delivers the event, the next rebuilds what it changed.
    await tester.pump();
    await tester.pump();
  }

  Future<void> pumpPage(WidgetTester tester, {ThemeData? theme, double scale = 1.0}) async {
    await c.start();
    await pumpDownloadWidget(tester, DownloadProgressPage(controller: c), theme: theme, textScale: scale, framed: true);
  }

  List<DownloadStepState> steps(WidgetTester tester) =>
      [for (final r in tester.widgetList<DownloadStepRow>(find.byType(DownloadStepRow))) r.state];

  DownloadActionButton pauseButton(WidgetTester tester) =>
      tester.widget<DownloadActionButton>(find.byType(DownloadActionButton));

  testWidgets('starting the job resolves the pack and lands in downloading', (tester) async {
    await c.start();
    expect(c.ui.value, DownloadUiState.downloading);
    expect(c.pack.value?.grade, 9);
  });

  testWidgets('hero shows the pack line, percent and bar from the progress', (tester) async {
    await pumpPage(tester);
    await emit(tester, DownloadPhase.downloading, 62);

    final hero = tester.widget<DownloadHeroCard>(find.byType(DownloadHeroCard));
    expect(hero.title, '${DownloadStrings.packTitlePrefix} ${GradeOrdinals.of(9)}');
    const sep = DownloadStrings.packLineSeparator;
    expect(
      hero.subtitle,
      '0 ${DownloadStrings.subjectsWord}$sep${DownloadStrings.versionWord} 1$sep${ByteFormatter.format(100)}',
    );
    expect(hero.percent, 62);
    expect(hero.progress, closeTo(0.62, 1e-9));
    expect(hero.sideText, DownloadStrings.onceOnly);
    expect(tester.widget<DownloadHeroBar>(find.byType(DownloadHeroBar)).progress, closeTo(0.62, 1e-9));
  });

  testWidgets('shows the design texts and the offline note, not the tutor line', (tester) async {
    await pumpPage(tester);

    for (final text in [
      DownloadStrings.packTitle,
      DownloadStrings.spaceCheckStep,
      DownloadStrings.spaceCheckDone,
      DownloadStrings.contentStep,
      DownloadStrings.contentStepHint,
      DownloadStrings.integrityStep,
      DownloadStrings.integrityStepHint,
      DownloadStrings.installStep,
      DownloadStrings.installStepHint,
      DownloadStrings.stepLabel,
      AppStrings.pause,
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(find.textContaining(DownloadStrings.resumeTipLead, findRichText: true), findsOneWidget);
    expect(find.textContaining(DownloadStrings.resumeTipBody, findRichText: true), findsOneWidget);
    expect(tester.widget<DownloadInfoNote>(find.byType(DownloadInfoNote)).text, DownloadStrings.worksOffline);
    expect(find.textContaining('GB', findRichText: true), findsNothing);
  });

  testWidgets('steps while downloading', (tester) async {
    await pumpPage(tester);
    await emit(tester, DownloadPhase.downloading, 30);
    expect(steps(tester), [_done, _active, _pending, _pending]);
  });

  for (final phase in [DownloadPhase.verifying, DownloadPhase.assembling]) {
    testWidgets('steps and disabled pause while ${phase.name}', (tester) async {
      await pumpPage(tester);
      await emit(tester, phase, 100);
      expect(steps(tester), [_done, _done, _active, _pending]);
      expect(find.text(DownloadStrings.contentDone), findsOneWidget);
      expect(pauseButton(tester).onPressed, isNull);
    });
  }

  testWidgets('pause asks the controller to pause', (tester) async {
    await pumpPage(tester);
    await emit(tester, DownloadPhase.downloading, 30);

    await tester.tap(find.byType(DownloadActionButton));
    await tester.pump();

    expect(h.pause.calls, 1);
    expect(c.ui.value, DownloadUiState.paused);
  });

  testWidgets('back pops the screen without canceling the download', (tester) async {
    await c.start();
    await pumpDownloadWidget(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (_) => DownloadProgressPage(controller: c)),
          ),
          child: const Text('open'),
        ),
      ),
      framed: true,
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadProgressPage), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(DownloadStrings.back));
    await tester.pumpAndSettle();

    expect(find.byType(DownloadProgressPage), findsNothing);
    expect(find.text('open'), findsOneWidget);
    expect(h.cancel.calls, 0);
    expect(c.ui.value, DownloadUiState.downloading);
  });

  for (final phase in [DownloadPhase.downloading, DownloadPhase.verifying, DownloadPhase.assembling]) {
    testWidgets('DownloadPage shows the progress screen while ${phase.name}', (tester) async {
      await c.start();
      await pumpDownloadWidget(tester, const DownloadPage(), framed: true);
      await emit(tester, phase, 50);
      expect(find.byType(DownloadProgressPage), findsOneWidget);
    });
  }

  for (final (theme, data, scale) in downloadRenderMatrix) {
    for (final phase in [DownloadPhase.downloading, DownloadPhase.verifying]) {
      testWidgets('renders without overflow ($theme, ×$scale, ${phase.name})', (tester) async {
        await pumpPage(tester, theme: data, scale: scale);
        await emit(tester, phase, 62);
        expect(tester.takeException(), isNull);
        expect(find.byType(DownloadHeroCard), findsOneWidget);
      });
    }
  }
}
