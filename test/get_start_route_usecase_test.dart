import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/content_manager/domain/entities/pack_schema_status.dart';
import 'package:mualimi/features/content_manager/domain/repositories/installed_content_repository.dart';
import 'package:mualimi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mualimi/features/onboarding/domain/usecases/get_start_route_usecase.dart';

class _FakeOnboardingRepository implements OnboardingRepository {
  _FakeOnboardingRepository({required this.isOnboardingDone, this.hasGrade = true});

  @override
  final bool isOnboardingDone;

  @override
  final bool hasGrade;

  @override
  Future<void> saveStudentName(String name) async {}

  @override
  Future<void> saveGrade(int grade) async {}
}

class _FakeInstalledContentRepository implements InstalledContentRepository {
  _FakeInstalledContentRepository(this.schema);

  final PackSchemaStatus? schema;
  int schemaChecks = 0;

  @override
  Future<int?> installedPackVersion() async => schema == null ? null : 1;

  @override
  Future<bool> isPackInstalled() async => schema == PackSchemaStatus.compatible;

  @override
  Future<PackSchemaStatus?> installedSchemaStatus() async {
    schemaChecks++;
    return schema;
  }
}

Future<String> _route(
  PackSchemaStatus? schema, {
  bool done = true,
  bool hasGrade = true,
}) =>
    GetStartRouteUseCase(
      _FakeOnboardingRepository(isOnboardingDone: done, hasGrade: hasGrade),
      _FakeInstalledContentRepository(schema),
    )();

void main() {
  group('GetStartRouteUseCase', () {
    test('onboarding not done goes to welcome without reading the pack', () async {
      final installed = _FakeInstalledContentRepository(PackSchemaStatus.compatible);
      final useCase = GetStartRouteUseCase(
          _FakeOnboardingRepository(isOnboardingDone: false), installed);
      expect(await useCase(), AppRoutes.welcome);
      expect(installed.schemaChecks, 0);
    });

    test('a compatible pack, as the development seed installs, goes to the shell',
        () async {
      expect(await _route(PackSchemaStatus.compatible), AppRoutes.shell);
    });

    test('a compatible pack goes to the shell even without a stored grade', () async {
      expect(await _route(PackSchemaStatus.compatible, hasGrade: false), AppRoutes.shell);
    });

    for (final schema in [
      PackSchemaStatus.outdated,
      PackSchemaStatus.newer,
      PackSchemaStatus.unreadable,
    ]) {
      test('a ${schema.name} pack is downloaded again for the stored grade', () async {
        expect(await _route(schema), AppRoutes.download);
      });

      test('a ${schema.name} pack without a stored grade restarts at welcome', () async {
        expect(await _route(schema, hasGrade: false), AppRoutes.welcome);
      });
    }

    test('onboarding done but no pack restarts at welcome', () async {
      expect(await _route(null), AppRoutes.welcome);
    });
  });
}
