import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_failed_page.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_page.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_action_button.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_failed_checklist.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_icon.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_icons.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_status_header.dart';

import '../helpers/pack_download_fakes.dart';
import 'download_widgets_harness.dart';

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

  DownloadStatusHeader header(WidgetTester tester) =>
      tester.widget<DownloadStatusHeader>(find.byType(DownloadStatusHeader));

  bool showsIcon(String path) => find.byWidgetPredicate((w) => w is DownloadIcon && w.path == path).evaluate().isNotEmpty;

  for (final (name, failure) in [('integrity', const IntegrityFailure()), ('generic', const NetworkFailure())]) {
    testWidgets('$name failure lands in the failed state', (tester) async {
      c.failWith(failure);
      expect(c.ui.value, DownloadUiState.failed);
    });

    testWidgets('$name button downloads again', (tester) async {
      c.failWith(failure);
      await pumpDownloadWidget(tester, DownloadFailedPage(controller: c), framed: true);
      expect(h.download.jobs, isEmpty);

      await tester.tap(find.byType(DownloadActionButton));
      await tester.pump();

      expect(h.download.files, ['pack-9-v1.zip']);
      expect(c.ui.value, DownloadUiState.downloading);
    });

    for (final (theme, data, scale) in downloadRenderMatrix) {
      testWidgets('$name renders without overflow ($theme, ×$scale)', (tester) async {
        c.failWith(failure);
        await pumpDownloadWidget(tester, DownloadFailedPage(controller: c), theme: data, textScale: scale, framed: true);
        expect(tester.takeException(), isNull);
        expect(find.byType(DownloadStatusHeader), findsOneWidget);
      });
    }
  }

  testWidgets('integrity failure shows the design texts, checklist and icons', (tester) async {
    c.failWith(const IntegrityFailure());
    await pumpDownloadWidget(tester, DownloadFailedPage(controller: c), framed: true);

    for (final text in [
      DownloadStrings.packTitle,
      DownloadStrings.integrityTitle,
      DownloadStrings.integrityBody,
      DownloadStrings.spaceCheckStep,
      DownloadStrings.spaceCheckDone,
      DownloadStrings.contentStep,
      DownloadStrings.contentDone,
      DownloadStrings.integrityStep,
      DownloadStrings.integrityMismatch,
      DownloadStrings.stepLabel,
      DownloadStrings.redownload,
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(find.text(AppStrings.downloadFailed), findsNothing);
    expect(find.text(AppStrings.retry), findsNothing);
    expect(find.byType(DownloadFailedChecklist), findsOneWidget);
    expect(header(tester).variant, DownloadStatusVariant.warning);
    expect(header(tester).iconPath, DownloadIcons.shieldCheck);
    expect(showsIcon(DownloadIcons.download), isTrue);
  });

  testWidgets('generic failure shows the failed title, body and retry', (tester) async {
    c.failWith(const NetworkFailure());
    await pumpDownloadWidget(tester, DownloadFailedPage(controller: c), framed: true);

    expect(find.text(AppStrings.downloadFailed), findsOneWidget);
    expect(find.text(DownloadStrings.failedBody), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
    expect(find.text(DownloadStrings.integrityTitle), findsNothing);
    expect(find.byType(DownloadFailedChecklist), findsNothing);
    expect(header(tester).variant, DownloadStatusVariant.warning);
    expect(header(tester).iconPath, DownloadIcons.info);
    expect(showsIcon(DownloadIcons.refresh), isTrue);
  });

  testWidgets('back returns to the previous screen', (tester) async {
    c.failWith(const NetworkFailure());
    await pumpDownloadWidget(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (_) => DownloadFailedPage(controller: c)),
          ),
          child: const Text('open'),
        ),
      ),
      framed: true,
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadFailedPage), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(DownloadStrings.back));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadFailedPage), findsNothing);
  });

  testWidgets('DownloadPage shows the Failed screen in the failed state', (tester) async {
    c.failWith(const IntegrityFailure());
    await pumpDownloadWidget(tester, const DownloadPage(), framed: true);

    expect(find.byType(DownloadFailedPage), findsOneWidget);
    expect(find.byType(DownloadFailedChecklist), findsOneWidget);
  });
}
