import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_pack_line.dart';
import 'package:mualimi/features/content_manager/presentation/controllers/download_ui_state.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_paused_page.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_progress_page.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_hero_card.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/download_step_state.dart';

import 'download_paused_fixture.dart';

const _done = DownloadStepState.done;
const _active = DownloadStepState.active;
const _pending = DownloadStepState.pending;

void main() {
  late DownloadPausedFixture f;

  setUp(() => f = DownloadPausedFixture());
  tearDown(() => f.dispose());

  testWidgets('user pause shows the paused banner, saved percent and resume/cancel', (tester) async {
    await f.show(tester, 'user');

    expect(find.byType(DownloadPausedPage), findsOneWidget);
    for (final text in [AppStrings.downloadPaused, DownloadStrings.pausedSavedNote, AppStrings.resume, AppStrings.cancel]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(find.text(DownloadStrings.contentStepHint), findsOneWidget);
    expect(find.text(DownloadStrings.waitingForConnection), findsNothing);
    expect(f.buttons(tester), [AppStrings.resume, AppStrings.cancel]);
    expect(f.steps(tester), [_done, _active, _pending, _pending]);
    final hero = f.hero(tester);
    expect(hero.subtitle, DownloadPackLine.pausedDetails(62));
    expect(hero.percent, 62);
    expect(hero.fill, DownloadHeroFill.muted);
  });

  testWidgets('resume asks the controller to resume', (tester) async {
    await f.show(tester, 'user');
    await tester.tap(find.text(AppStrings.resume));
    await f.settle(tester);

    expect(f.h.resume.calls, 1);
    expect(f.c.ui.value, DownloadUiState.downloading);
    expect(find.byType(DownloadProgressPage), findsOneWidget);
  });

  testWidgets('cancel asks the controller to cancel', (tester) async {
    await f.show(tester, 'user');
    await tester.tap(find.text(AppStrings.cancel));
    await f.settle(tester);

    expect(f.h.cancel.calls, 1);
    expect(f.c.ui.value, DownloadUiState.idle);
    expect(find.text(AppStrings.startDownload), findsOneWidget);
  });

  testWidgets('a pause before any byte arrived shows the pack line and pending steps', (tester) async {
    await f.c.start();
    await f.c.pause();
    await f.pumpPage(tester);

    expect(f.hero(tester).subtitle, DownloadPackLine.details(f.c.pack.value!));
    expect(f.steps(tester), [_pending, _pending, _pending, _pending]);
  });
}
