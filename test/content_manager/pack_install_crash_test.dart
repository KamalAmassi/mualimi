import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_installer.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_recovery.dart';
import 'package:path/path.dart' as p;

import '../helpers/content_db_fixture.dart';
import 'pack_install_fakes.dart';

/// Stops the real installer forever at one step (as if the app were killed
/// there), then checks what the next launch's recovery makes of the disk.
void main() {
  late Directory root;
  late TempPackInstallHost host;
  late File zip;

  File writeZip() {
    final dbPath = p.join(root.path, 'fixture.db');
    final db = writeContentDb(dbPath,
        schemaVersion: '${ContentDatabase.packSchemaVersion}', marker: 'new-db');
    final archive = Archive()
      ..addFile(ArchiveFile.bytes('content.db', db.readAsBytesSync()))
      ..addFile(ArchiveFile.string('pdf/new.pdf', 'new'))
      ..addFile(ArchiveFile.string('images/new.webp', 'new'));
    db.deleteSync();
    return File(p.join(root.path, 'pack.zip'))
      ..writeAsBytesSync(ZipEncoder().encode(archive));
  }

  /// Starts an install whose [stopAtRename]-th rename (1-based) never returns.
  Future<void> installUntilRename(int stopAtRename) async {
    final reached = Completer<void>();
    var calls = 0;
    final installer = PackInstaller.withHost(host, rename: (e, newPath) {
      if (++calls == stopAtRename) {
        reached.complete();
        return Completer<FileSystemEntity>().future;
      }
      return e.rename(newPath);
    });
    unawaited(installer.install(zip, 2));
    await reached.future;
  }

  Future<void> installUntilVersionWrite({required bool storeFirst}) async {
    host.hangOnVersion = (storeFirst: storeFirst);
    unawaited(PackInstaller.withHost(host).install(zip, 2));
    await host.versionReached.future;
  }

  Future<void> relaunch() {
    host.hangOnVersion = null;
    return PackRecovery.withHost(host).run();
  }

  void expectPack({required bool isNew}) {
    expect(host.dbMarker(), isNew ? 'new-db' : 'old-db');
    expect(host.exists('pdf/new.pdf'), isNew);
    expect(host.exists('pdf/old.pdf'), !isNew);
    expect(host.exists('images/new.webp'), isNew);
    expect(host.exists('images/old.webp'), !isNew);
    expect(host.version, isNew ? 2 : 1);
    expect(host.leftovers(), isEmpty);
  }

  setUp(() {
    root = Directory.systemTemp.createTempSync('pack_install_crash_');
    host = TempPackInstallHost(root, version: 1);
    host.writeDb('content.db', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writeImage('images', 'old.webp');
    zip = writeZip();
  });

  tearDown(() {
    try {
      root.deleteSync(recursive: true);
    } on FileSystemException {
      // The stopped install may still hold the zip open on Windows.
    }
  });

  const renameSteps = {
    1: 'before content.db is backed up',
    2: 'before the new content.db is placed',
    3: 'before pdf/ is backed up',
    4: 'before the new pdf/ is placed',
    5: 'before images/ is backed up',
    6: 'before the new images/ is placed',
  };
  renameSteps.forEach((step, label) {
    test('killed $label: old pack and version come back', () async {
      await installUntilRename(step);
      expect(host.exists('install_journal.json'), isTrue);
      await relaunch();
      expectPack(isNew: false);
    });
  });

  test('killed while writing the version: old pack and version come back',
      () async {
    await installUntilVersionWrite(storeFirst: false);
    await relaunch();
    expectPack(isNew: false);
  });

  test('killed after the version was stored: new pack is kept', () async {
    await installUntilVersionWrite(storeFirst: true);
    await relaunch();
    expectPack(isNew: true);
  });

  test('a finished install leaves no journal', () async {
    await PackInstaller.withHost(host).install(zip, 2);
    expectPack(isNew: true);
  });

  for (final staged in ['pdf', 'images']) {
    test('a rolled back install at staging/$staged leaves no journal', () async {
      var failed = false;
      final installer = PackInstaller.withHost(host, rename: (e, newPath) async {
        if (!failed && e.path.endsWith(p.join('staging', staged))) {
          failed = true;
          throw const FileSystemException('simulated rename failure');
        }
        return e.rename(newPath);
      });
      await expectLater(installer.install(zip, 2), throwsA(isA<FileSystemException>()));
      expectPack(isNew: false);
    });
  }
}
