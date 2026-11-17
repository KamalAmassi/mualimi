import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/core/theme/app_theme.dart';
import 'package:mualimi/features/lesson/domain/entities/key_term.dart';
import 'package:mualimi/features/lesson/presentation/controllers/key_terms_controller.dart';
import 'package:mualimi/features/lesson/presentation/pages/key_terms_page.dart';
import 'package:mualimi/features/lesson/presentation/widgets/key_terms_strings.dart';

import 'key_terms_fakes.dart';

const _designSize = Size(390, 844);

Future<KeyTermsController> _pump(
  WidgetTester tester, {
  List<KeyTerm>? terms,
  ThemeData? theme,
  double textScale = 1,
}) async {
  final controller = Get.put(keyTermsController(FakeKeyTermsRepository(terms: terms)));
  tester.view.physicalSize = _designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(GetMaterialApp(
    theme: theme ?? AppTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: Directionality(textDirection: TextDirection.rtl, child: child!),
    ),
    initialRoute: AppRoutes.keyTermsOf('lesson-1'),
    getPages: [GetPage(name: AppRoutes.keyTerms, page: () => const KeyTermsPage())],
  ));
  await tester.pumpAndSettle();
  return controller;
}

Finder _button(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(TextButton));

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<TextButton>(_button(label)).onPressed != null;

void main() {
  tearDown(Get.reset);

  testWidgets('shows title, subtitle, counter, hint and the full list', (tester) async {
    await _pump(tester);
    expect(find.text(KeyTermsStrings.title), findsOneWidget);
    expect(find.text(KeyTermsStrings.subtitle(keyTermsLessonTitle, 3)), findsOneWidget);
    expect(find.text(KeyTermsStrings.counter(1, 3)), findsOneWidget);
    expect(find.text(KeyTermsStrings.flipHint), findsOneWidget);
    expect(find.text(KeyTermsStrings.allTerms), findsOneWidget);
    expect(find.text('Charge'), findsNWidgets(2));
    for (final term in keyTermsSample) {
      expect(find.text(term.definition), findsOneWidget);
    }
  });

  testWidgets('tapping the card shows the definition, tapping again goes back', (tester) async {
    await _pump(tester);
    await tester.tap(find.text(KeyTermsStrings.flipHint));
    await tester.pumpAndSettle();
    expect(find.text('Property of matter.'), findsNWidgets(2));
    await tester.tap(find.text(KeyTermsStrings.flipHint));
    await tester.pumpAndSettle();
    expect(find.text('Property of matter.'), findsOneWidget);
    expect(find.text('Charge'), findsNWidgets(2));
  });

  testWidgets('previous and next are disabled at the ends', (tester) async {
    await _pump(tester);
    expect(_enabled(tester, KeyTermsStrings.previous), isFalse);
    expect(_enabled(tester, KeyTermsStrings.next), isTrue);
    await tester.tap(_button(KeyTermsStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(KeyTermsStrings.counter(2, 3)), findsOneWidget);
    expect(_enabled(tester, KeyTermsStrings.previous), isTrue);
    await tester.tap(_button(KeyTermsStrings.next));
    await tester.pumpAndSettle();
    expect(find.text(KeyTermsStrings.counter(3, 3)), findsOneWidget);
    expect(_enabled(tester, KeyTermsStrings.next), isFalse);
    await tester.tap(_button(KeyTermsStrings.previous));
    await tester.pumpAndSettle();
    expect(find.text(KeyTermsStrings.counter(2, 3)), findsOneWidget);
  });

  testWidgets('tapping a term in the list jumps to its card', (tester) async {
    final controller = await _pump(tester);
    await tester.scrollUntilVisible(find.text('Neutral'), 100);
    await tester.tap(find.text('Neutral'));
    await tester.pumpAndSettle();
    expect(controller.index.value, 1);
    expect(controller.scrollController.offset, 0);
    expect(find.text(KeyTermsStrings.counter(2, 3)), findsOneWidget);
    expect(find.text('Neutral'), findsNWidgets(2));
  });

  testWidgets('a lesson without key terms shows the empty state', (tester) async {
    await _pump(tester, terms: const []);
    expect(find.text(KeyTermsStrings.empty), findsOneWidget);
    expect(find.text(KeyTermsStrings.subtitle(keyTermsLessonTitle, 0)), findsOneWidget);
    expect(find.text(KeyTermsStrings.flipHint), findsNothing);
    expect(find.text(KeyTermsStrings.allTerms), findsNothing);
  });

  for (final (name, theme) in [('light', AppTheme.light), ('dark', AppTheme.dark)]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$name × $scale lays out both sides without overflow', (tester) async {
        final controller = await _pump(tester, theme: theme, textScale: scale);
        expect(tester.takeException(), isNull);
        controller.showCard(2);
        controller.flip();
        await tester.pumpAndSettle();
        expect(find.text(keyTermsLongDefinition), findsWidgets);
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
