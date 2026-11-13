import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mualimi/features/onboarding/domain/usecases/get_start_route_usecase.dart';

class _FakeOnboardingRepository implements OnboardingRepository {
  _FakeOnboardingRepository({required this.done, required this.packInstalled});

  final bool done;
  final bool packInstalled;
  int packChecks = 0;

  @override
  bool get isOnboardingDone => done;

  @override
  Future<bool> isPackInstalled() async {
    packChecks++;
    return packInstalled;
  }

  @override
  Future<void> saveStudentName(String name) async {}

  @override
  Future<void> saveGrade(int grade) async {}
}

void main() {
  group('GetStartRouteUseCase', () {
    test('onboarding done and pack installed goes to the shell', () async {
      final repo = _FakeOnboardingRepository(done: true, packInstalled: true);
      expect(await GetStartRouteUseCase(repo)(), AppRoutes.shell);
    });

    test('onboarding done but no pack restarts at welcome', () async {
      final repo = _FakeOnboardingRepository(done: true, packInstalled: false);
      expect(await GetStartRouteUseCase(repo)(), AppRoutes.welcome);
    });

    test('onboarding not done goes to welcome without checking the pack', () async {
      final repo = _FakeOnboardingRepository(done: false, packInstalled: true);
      expect(await GetStartRouteUseCase(repo)(), AppRoutes.welcome);
      expect(repo.packChecks, 0);
    });
  });
}
