import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/pack_download_controller.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_no_space_page.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_page.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_action_button.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_status_header.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/space_compare_card.dart';

import '../helpers/pack_download_fakes.dart';
import 'download_widgets_harness.dart';

const _required = 900 * 1024 * 1024;
const _free = 300 * 1024 * 1024;

void main() {
  late PackDownloadHarness h;
  late PackDownloadController c;

  setUp(() {
    h = PackDownloadHarness();
    c = Get.put(h.build(autoStart: false));
    c.failWith(const NotEnoughSpaceFailure(requiredBytes: _required, freeBytes: _free));
  });

  tearDown(() {
    h.download.closeAll();
    Get.reset();
  });

  testWidgets('the controller lands in noSpace for a NotEnoughSpaceFailure', (tester) async {
    expect(c.ui.value, DownloadUiState.noSpace);
  });

  testWidgets('shows the design texts, sizes and button', (tester) async {
    await pumpDownloadWidget(tester, DownloadNoSpacePage(controller: c), framed: true);

    expect(find.text(DownloadStrings.packTitle), findsOneWidget);
    expect(find.text(DownloadStrings.noSpaceTitle), findsOneWidget);
    expect(find.text(DownloadStrings.noSpaceBody), findsOneWidget);
    expect(find.text(DownloadStrings.stepLabel), findsOneWidget);
    expect(find.text(DownloadStrings.checkAgain), findsOneWidget);
    expect(find.text(ByteFormatter.format(_required)), findsOneWidget);
    expect(find.text(ByteFormatter.format(_free)), findsOneWidget);
    expect(
      tester.widget<DownloadStatusHeader>(find.byType(DownloadStatusHeader)).variant,
      DownloadStatusVariant.error,
    );
    expect(tester.widget<DownloadActionButton>(find.byType(DownloadActionButton)).onPressed, isNotNull);
  });

  testWidgets('hides the compare card for any other failure', (tester) async {
    c.failure.value = const NetworkFailure();
    await pumpDownloadWidget(tester, DownloadNoSpacePage(controller: c), framed: true);

    expect(find.byType(SpaceCompareCard), findsNothing);
    expect(find.text(DownloadStrings.noSpaceTitle), findsOneWidget);
  });

  testWidgets('check again starts the download again', (tester) async {
    await pumpDownloadWidget(tester, DownloadNoSpacePage(controller: c), framed: true);
    expect(h.download.jobs, isEmpty);

    await tester.tap(find.text(DownloadStrings.checkAgain));
    await tester.pump();

    expect(h.download.files, ['pack-9-v1.zip']);
    expect(c.ui.value, DownloadUiState.downloading);
  });

  testWidgets('back returns to the previous screen', (tester) async {
    await pumpDownloadWidget(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (_) => DownloadNoSpacePage(controller: c)),
          ),
          child: const Text('open'),
        ),
      ),
      framed: true,
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadNoSpacePage), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(DownloadStrings.back));
    await tester.pumpAndSettle();
    expect(find.byType(DownloadNoSpacePage), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('DownloadPage shows the NoSpace screen in the noSpace state', (tester) async {
    await pumpDownloadWidget(tester, const DownloadPage(), framed: true);

    expect(find.byType(DownloadNoSpacePage), findsOneWidget);
    expect(find.byType(SpaceCompareCard), findsOneWidget);
  });
}
