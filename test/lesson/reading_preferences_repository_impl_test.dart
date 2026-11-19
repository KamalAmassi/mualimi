import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/services/settings_service.dart';
import 'package:mualimi/features/lesson/data/repositories/reading_preferences_repository_impl.dart';

void main() {
  late Directory dir;

  setUp(() async => dir = await Directory.systemTemp.createTemp('reading_prefs'));
  tearDown(() => dir.delete(recursive: true));

  test('a saved font scale survives a restart', () async {
    final file = File('${dir.path}/settings.json');
    final repository = ReadingPreferencesRepositoryImpl(await SettingsService(file).init());
    expect(repository.fontScale, 1.0);

    await repository.saveFontScale(1.15);

    final reloaded = ReadingPreferencesRepositoryImpl(await SettingsService(file).init());
    expect(reloaded.fontScale, 1.15);
  });
}
