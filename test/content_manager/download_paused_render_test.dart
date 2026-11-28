import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_strings.dart';
import 'package:mualimi/features/content_manager/presentation/pages/download_paused_page.dart';

import 'download_paused_fixture.dart';
import 'download_widgets_harness.dart';

const _variants = ['user', 'network', 'wifi'];

void main() {
  late DownloadPausedFixture f;

  setUp(() => f = DownloadPausedFixture());
  tearDown(() => f.dispose());

  for (final (theme, data, scale) in downloadRenderMatrix) {
    for (final name in _variants) {
      testWidgets('renders without overflow ($theme, ×$scale, $name)', (tester) async {
        await f.show(tester, name, theme: data, scale: scale);
        expect(tester.takeException(), isNull);
        expect(find.byType(DownloadPausedPage), findsOneWidget);
      });
    }
  }

  for (final name in _variants) {
    testWidgets('cancel stays on screen when the body scrolls ($name, ×2.0)', (tester) async {
      await f.show(tester, name, scale: 2.0);
      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(tester.getRect(find.text(AppStrings.cancel)).bottom, lessThanOrEqualTo(screen.height));
      expect(find.text(AppStrings.cancel).hitTestable(), findsOneWidget);
    });
  }
}
