import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/onboarding/domain/usecases/get_start_route_usecase.dart';
import 'package:mualimi/features/onboarding/presentation/controllers/splash_controller.dart';
import 'package:mualimi/features/onboarding/presentation/controllers/splash_timing.dart';

/// Resolves the start route after [checkTime] of (fake) time.
class _FakeGetStartRoute implements GetStartRouteUseCase {
  _FakeGetStartRoute(this.checkTime);
  final Duration checkTime;

  @override
  Future<String> call() => Future<String>.delayed(checkTime, () => AppRoutes.welcome);
}

const _splashText = 'splash';
const _welcomeText = 'welcome';

Future<void> _pumpSplash(WidgetTester tester, {required Duration checkTime, Duration? minDisplay}) async {
  await tester.pumpWidget(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const Text(_splashText)),
      GetPage(name: AppRoutes.welcome, page: () => const Text(_welcomeText)),
    ],
  ));
  final fake = _FakeGetStartRoute(checkTime);
  Get.put(minDisplay == null ? SplashController(fake) : SplashController(fake, minDisplay: minDisplay));
  await tester.pump(); // runs onReady, which starts the check and the delay
}

Future<bool> _navigated(WidgetTester tester) async {
  await tester.pump();
  return Get.currentRoute == AppRoutes.welcome;
}

void main() {
  tearDown(Get.reset);

  test('default minimum display is 1500 ms', () {
    expect(SplashTiming.minDisplay, const Duration(milliseconds: 1500));
  });

  testWidgets('a fast check still waits for the minimum display time', (tester) async {
    await _pumpSplash(tester, checkTime: Duration.zero);

    await tester.pump(SplashTiming.minDisplay - const Duration(milliseconds: 1));
    expect(await _navigated(tester), isFalse);
    expect(find.text(_splashText), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    expect(await _navigated(tester), isTrue);
    await tester.pumpAndSettle();
    expect(find.text(_welcomeText), findsOneWidget);
  });

  testWidgets('a slow check sets the wait, with no delay added on top', (tester) async {
    const checkTime = Duration(milliseconds: 3000);
    await _pumpSplash(tester, checkTime: checkTime);

    await tester.pump(checkTime - const Duration(milliseconds: 1));
    expect(await _navigated(tester), isFalse);

    // Navigates at max(3000, 1500) = 3000 ms, not 3000 + 1500.
    await tester.pump(const Duration(milliseconds: 1));
    expect(await _navigated(tester), isTrue);
  });

  testWidgets('the minimum display time is injectable', (tester) async {
    await _pumpSplash(tester, checkTime: Duration.zero, minDisplay: Duration.zero);
    await tester.pump(Duration.zero); // zero-length timers still fire on the next tick
    expect(await _navigated(tester), isTrue);
  });
}
