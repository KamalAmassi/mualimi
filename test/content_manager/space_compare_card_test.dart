import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/constants/app_colors.dart';
import 'package:mualimi/core/utils/byte_formatter.dart';
import 'package:mualimi/features/content_manager/presentation/constants/download_strings.dart';
import 'package:mualimi/features/content_manager/presentation/widgets/space_compare_card.dart';

import 'download_widgets_harness.dart';

const _mb = 1024 * 1024;

double _fill(WidgetTester tester) => tester
    .widget<FractionallySizedBox>(
      find.descendant(of: find.byType(SpaceCompareCard), matching: find.byType(FractionallySizedBox)),
    )
    .widthFactor!;

void main() {
  testWidgets('shows both labels and formatted sizes', (tester) async {
    await pumpDownloadWidget(tester, const SpaceCompareCard(requiredBytes: 900 * _mb, availableBytes: 300 * _mb));

    expect(find.text(DownloadStrings.requiredLabel), findsOneWidget);
    expect(find.text(DownloadStrings.availableLabel), findsOneWidget);
    expect(find.text(ByteFormatter.format(900 * _mb)), findsOneWidget);
    expect(find.text(ByteFormatter.format(300 * _mb)), findsOneWidget);
  });

  testWidgets('sizes use Western digits, LTR, and available is in the error colour', (tester) async {
    await pumpDownloadWidget(tester, const SpaceCompareCard(requiredBytes: 2 * 1024 * _mb, availableBytes: 512 * _mb));

    final required = tester.widget<Text>(find.text(ByteFormatter.format(2 * 1024 * _mb)));
    final available = tester.widget<Text>(find.text(ByteFormatter.format(512 * _mb)));
    expect(required.data, startsWith('2.0 '));
    expect(available.data, startsWith('512.0 '));
    expect(required.textDirection, TextDirection.ltr);
    expect(available.textDirection, TextDirection.ltr);
    expect(available.style?.color, AppColors.light.error);
    expect(required.style?.color, AppColors.light.textPrimary);
  });

  group('bar fill', () {
    testWidgets('is available over required', (tester) async {
      await pumpDownloadWidget(tester, const SpaceCompareCard(requiredBytes: 1000, availableBytes: 700));
      expect(_fill(tester), closeTo(0.7, 1e-9));
    });

    testWidgets('is full when available exceeds required', (tester) async {
      await pumpDownloadWidget(tester, const SpaceCompareCard(requiredBytes: 100, availableBytes: 500));
      expect(_fill(tester), 1.0);
    });

    testWidgets('is full when required is zero', (tester) async {
      await pumpDownloadWidget(tester, const SpaceCompareCard(requiredBytes: 0, availableBytes: 0));
      expect(_fill(tester), 1.0);
    });

    testWidgets('is empty when nothing is free', (tester) async {
      await pumpDownloadWidget(tester, const SpaceCompareCard(requiredBytes: 100, availableBytes: 0));
      expect(_fill(tester), 0.0);
    });
  });

  for (final (name, theme, scale) in downloadRenderMatrix) {
    testWidgets('renders without overflow ($name, x$scale)', (tester) async {
      await pumpDownloadWidget(
        tester,
        const SpaceCompareCard(requiredBytes: 900 * _mb, availableBytes: 300 * _mb),
        theme: theme,
        textScale: scale,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
