import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/bindings/initial_binding.dart';
import 'package:mualimi/core/constants/app_files.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_loader.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';

class _OfflineConnectivity extends Fake implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async =>
      [ConnectivityResult.none];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      const Stream.empty();
}

class _Device implements DeviceInfoSource {
  @override
  Future<DeviceSnapshot> read() async =>
      const DeviceSnapshot(freeDiskBytes: 100 << 30);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('DevSeedLoader.isEnabled', () {
    test('is allowed in debug and profile builds when the flag is set', () {
      expect(
          DevSeedLoader.isEnabled(releaseMode: false, flagSet: true), isTrue);
    });

    test('is blocked in release builds even when the flag is set', () {
      expect(
          DevSeedLoader.isEnabled(releaseMode: true, flagSet: true), isFalse);
    });

    test('is off without the flag in any build mode', () {
      expect(
          DevSeedLoader.isEnabled(releaseMode: false, flagSet: false), isFalse);
      expect(
          DevSeedLoader.isEnabled(releaseMode: true, flagSet: false), isFalse);
    });

    test('is off by default when the flag is not passed', () {
      expect(DevSeedLoader.isEnabled(), isFalse);
    });
  });

  group('first start', () {
    late Directory root;

    setUp(() async => root = await Directory.systemTemp.createTemp('seed'));

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      try {
        await root.delete(recursive: true);
      } on FileSystemException {
        // Drift's isolate may still hold the file on Windows.
      }
    });

    Future<InitialBinding> start({required bool installDevSeed}) =>
        InitialBinding.create(
          rootOverride: root,
          connectivityPlugin: _OfflineConnectivity(),
          deviceInfo: _Device(),
          installDevSeed: installDevSeed,
        );

    File contentDb() =>
        File('${root.path}/${AppFiles.packsDir}/${AppFiles.contentDb}');

    test('without the seed nothing is installed and onboarding is still needed',
        () async {
      final binding = await start(installDevSeed: false);
      expect(contentDb().existsSync(), isFalse);
      expect(binding.settings.onboardingDone.value, isFalse);
      expect(binding.settings.installedPackVersion.value, isNull);
    });

    test('with the seed a pack is installed and onboarding is done', () async {
      final binding = await start(installDevSeed: true);
      expect(contentDb().existsSync(), isTrue);
      expect(binding.settings.onboardingDone.value, isTrue);
      expect(binding.settings.grade.value, 9);
      expect(binding.settings.installedPackVersion.value, 1);
    });

    test('an already installed pack is never replaced by the seed', () async {
      await start(installDevSeed: true);
      final before = contentDb().lastModifiedSync();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await start(installDevSeed: true);
      expect(contentDb().lastModifiedSync(), before);
    });

    test('a pack from an older schema is deleted and rebuilt', () async {
      contentDb().parent.createSync(recursive: true);
      final old = sqlite.sqlite3.open(contentDb().path);
      old.execute('CREATE TABLE pack_meta (key TEXT PRIMARY KEY, value TEXT)');
      old.execute("INSERT INTO pack_meta VALUES ('schema_version', '2')");
      old.close();
      await start(installDevSeed: true);
      final rebuilt =
          sqlite.sqlite3.open(contentDb().path, mode: sqlite.OpenMode.readOnly);
      final version = rebuilt
          .select("SELECT value FROM pack_meta WHERE key = 'schema_version'")
          .first['value'];
      rebuilt.close();
      expect(version, '4');
    });
  });
}
