import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/services/network_kind.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_phase.dart';
import 'package:mualimi/features/content_manager/domain/entities/download_progress.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_page.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_action_button.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_hero_card.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_row.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

import '../helpers/pack_download_fakes.dart';
import 'download_widgets_harness.dart';

const pausedDebounce = Duration(milliseconds: 40);

/// A pack download controller on fakes, driven into each paused variant
/// while `DownloadPage` is on screen.
class DownloadPausedFixture {
  final h = PackDownloadHarness();
  late final PackDownloadController c = Get.put(h.build(autoStart: false, networkDebounce: pausedDebounce));

  void dispose() {
    h.download.closeAll();
    Get.reset();
  }

  /// One pump delivers the change, the next rebuilds what it changed.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }

  /// Starts the job and lets 62 of 100 bytes arrive.
  Future<void> downloadSome(WidgetTester tester) async {
    await c.start();
    h.download.emit(const DownloadProgress(phase: DownloadPhase.downloading, bytesDone: 62, totalBytes: 100));
    await settle(tester);
  }

  Future<void> pumpPage(WidgetTester tester, {ThemeData? theme, double scale = 1.0}) =>
      pumpDownloadWidget(tester, const DownloadPage(), theme: theme, textScale: scale, framed: true);

  Future<void> pauseByUser(WidgetTester tester) async {
    await downloadSome(tester);
    await c.pause();
  }

  Future<void> loseNetwork(WidgetTester tester) async {
    await downloadSome(tester);
    h.connectivity.network.value = NetworkKind.offline;
    await settle(tester);
  }

  Future<void> waitForWifi(WidgetTester tester) async {
    await downloadSome(tester);
    c.waitForWifi();
  }

  /// Enters the paused variant [name] and shows the page.
  Future<void> show(WidgetTester tester, String name, {ThemeData? theme, double scale = 1.0}) async {
    await switch (name) {
      'user' => pauseByUser(tester),
      'network' => loseNetwork(tester),
      'wifi' => waitForWifi(tester),
      _ => throw ArgumentError(name),
    };
    await pumpPage(tester, theme: theme, scale: scale);
  }

  List<DownloadStepState> steps(WidgetTester tester) =>
      [for (final r in tester.widgetList<DownloadStepRow>(find.byType(DownloadStepRow))) r.state];

  List<String> buttons(WidgetTester tester) =>
      [for (final b in tester.widgetList<DownloadActionButton>(find.byType(DownloadActionButton))) b.label];

  DownloadHeroCard hero(WidgetTester tester) => tester.widget<DownloadHeroCard>(find.byType(DownloadHeroCard));
}
