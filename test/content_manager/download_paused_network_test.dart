import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/core/services/network_kind.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_progress_page.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

import 'download_paused_fixture.dart';

void main() {
  late DownloadPausedFixture f;

  setUp(() => f = DownloadPausedFixture());
  tearDown(() => f.dispose());

  group('network pause', () {
    testWidgets('says it waits for the network and resumes on its own', (tester) async {
      await f.show(tester, 'network');

      for (final text in [
        DownloadStrings.connectionLostTitle,
        DownloadStrings.connectionLostBody,
        DownloadStrings.waitingForConnection,
        DownloadStrings.resumeNow,
        AppStrings.cancel,
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.text(AppStrings.downloadPaused), findsNothing);
      expect(f.buttons(tester), [DownloadStrings.resumeNow, AppStrings.cancel]);
      expect(f.steps(tester), [
        DownloadStepState.done,
        DownloadStepState.active,
        DownloadStepState.pending,
        DownloadStepState.pending,
      ]);
    });

    testWidgets('resumes when the network returns', (tester) async {
      await f.show(tester, 'network');
      f.h.connectivity.network.value = NetworkKind.wifi;
      await tester.pump(pausedDebounce * 2);
      await f.settle(tester);

      expect(f.h.resume.calls, 1);
      expect(f.c.ui.value, DownloadUiState.downloading);
      expect(find.byType(DownloadProgressPage), findsOneWidget);
    });

    testWidgets('resume now while still offline keeps waiting', (tester) async {
      await f.show(tester, 'network');
      await tester.tap(find.text(DownloadStrings.resumeNow));
      await f.settle(tester);

      expect(f.h.resume.calls, 0);
      expect(find.text(DownloadStrings.connectionLostTitle), findsOneWidget);
    });
  });

  group('waiting for Wi-Fi', () {
    testWidgets('shows the Wi-Fi banner with cancel only', (tester) async {
      await f.show(tester, 'wifi');

      expect(find.text(AppStrings.waitingForWifi), findsOneWidget);
      expect(find.text(DownloadStrings.resumeTipBody), findsOneWidget);
      expect(find.text(DownloadStrings.waitingForConnection), findsOneWidget);
      expect(f.buttons(tester), [AppStrings.cancel]);
    });

    testWidgets('cancel asks the controller to cancel', (tester) async {
      await f.show(tester, 'wifi');
      await tester.tap(find.text(AppStrings.cancel));
      await f.settle(tester);

      expect(f.h.cancel.calls, 1);
      expect(f.c.ui.value, DownloadUiState.idle);
    });
  });
}
