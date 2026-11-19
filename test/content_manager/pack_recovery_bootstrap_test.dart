import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/bindings/initial_binding.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/core/services/device_info_source.dart';
import 'package:mualimi/core/services/device_snapshot.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_recovery.dart';
import 'package:path/path.dart' as p;

import 'pack_install_fakes.dart';

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
      const DeviceSnapshot(ramBytes: 4 << 30, freeDiskBytes: 10 << 30);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory root;
  late TempPackInstallHost host;
  DatabaseService? databases;

  setUp(() async {
    root = Directory.systemTemp.createTempSync('pack_recovery_boot_');
    host = TempPackInstallHost(root, version: 1);
    File(p.join(root.path, 'settings.json'))
        .writeAsStringSync(jsonEncode({'installed_pack_version': 2}));
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writeDb('staging/content.db', 'new-db');
    await host.writeJournal(from: 1, to: 2, swapsPdf: false);
  });

  tearDown(() async {
    await databases?.closeContent();
    await databases?.user.close();
    databases = null;
    Get.reset();
    try {
      await root.delete(recursive: true);
    } on FileSystemException {
      // The user DB's isolate may still hold its file on Windows.
    }
  });

  test('startup recovers the pack before the content DB is opened', () async {
    final binding = await InitialBinding.create(
      rootOverride: root,
      connectivityPlugin: _OfflineConnectivity(),
      deviceInfo: _Device(),
      beforeContentOpen: (paths, settings) =>
          PackRecovery(paths, settings).run(),
    );
    binding.dependencies();
    databases = Get.find<DatabaseService>();

    expect(databases!.hasContent, isTrue);
    expect(host.dbMarker(), 'old-db');
    expect(binding.settings.installedPackVersion.value, 1);
    expect(host.leftovers(), isEmpty);
  });

  test('without the hook the interrupted pack is not opened', () async {
    final binding = await InitialBinding.create(
      rootOverride: root,
      connectivityPlugin: _OfflineConnectivity(),
      deviceInfo: _Device(),
    );
    binding.dependencies();
    databases = Get.find<DatabaseService>();

    expect(databases!.hasContent, isFalse);
  });
}
