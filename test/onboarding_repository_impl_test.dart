import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;
  late SettingsService settings;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('onboarding_repo');
    settings = SettingsService(File(p.join(root.path, 'settings.json')));
  });

  tearDown(() => root.delete(recursive: true));

  test('hasGrade follows the stored grade', () async {
    final repository = OnboardingRepositoryImpl(settings);
    expect(repository.hasGrade, isFalse);

    await settings.setGrade(9);
    expect(repository.hasGrade, isTrue);
  });
}
