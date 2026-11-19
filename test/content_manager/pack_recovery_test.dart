import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_recovery.dart';

import 'pack_install_fakes.dart';

void main() {
  late Directory root;
  late TempPackInstallHost host;

  Future<void> recover() => PackRecovery.withHost(host).run();

  void expectOldPack() {
    expect(host.dbMarker(), 'old-db');
    expect(host.exists('pdf/old.pdf'), isTrue);
    expect(host.exists('pdf/new.pdf'), isFalse);
    expect(host.version, 1);
    expect(host.leftovers(), isEmpty);
  }

  void expectNewPack() {
    expect(host.dbMarker(), 'new-db');
    expect(host.exists('pdf/new.pdf'), isTrue);
    expect(host.exists('pdf/old.pdf'), isFalse);
    expect(host.version, 2);
    expect(host.leftovers(), isEmpty);
  }

  setUp(() {
    root = Directory.systemTemp.createTempSync('pack_recovery_');
    host = TempPackInstallHost(root, version: 1);
    host.packsDir.createSync(recursive: true);
  });

  tearDown(() => root.deleteSync(recursive: true));

  test('nothing to recover leaves the pack and version untouched', () async {
    host.writeDb('content.db', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    await recover();
    expectOldPack();
    expect(host.versionWrites, isEmpty);
  });

  test('killed during extract: staging is removed', () async {
    host.writeDb('content.db', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writeDb('staging/content.db', 'new-db');
    await recover();
    expectOldPack();
  });

  test('killed after content.db was backed up: backup is restored', () async {
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writeDb('staging/content.db', 'new-db');
    host.writePdf('staging/pdf', 'new.pdf');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectOldPack();
    expect(host.versionWrites, isEmpty);
  });

  test('killed after new content.db was placed: old db is restored', () async {
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writePdf('staging/pdf', 'new.pdf');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectOldPack();
  });

  test('killed after pdf/ was backed up: both backups are restored', () async {
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf.bak', 'old.pdf');
    host.writePdf('staging/pdf', 'new.pdf');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectOldPack();
  });

  test('killed before the version write: rolled back to the old version', () async {
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'new.pdf');
    host.writePdf('pdf.bak', 'old.pdf');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectOldPack();
  });

  test('killed after the version write: new pack is kept', () async {
    host.version = 2;
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'new.pdf');
    host.writePdf('pdf.bak', 'old.pdf');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectNewPack();
    expect(host.versionWrites, isEmpty);
  });

  test('killed during cleanup: remaining leftovers are removed', () async {
    host.version = 2;
    host.writeDb('content.db', 'new-db');
    host.writePdf('pdf', 'new.pdf');
    host.writePdf('pdf.bak', 'old.pdf');
    host.writeDb('staging/other.db', 'x');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectNewPack();
  });

  test('version is restored when it already names the new pack too early',
      () async {
    host.version = 2;
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf.bak', 'old.pdf');
    host.writePdf('staging/pdf', 'new.pdf');
    await host.writeJournal(from: 1, to: 2);
    await recover();
    expectOldPack();
    expect(host.versionWrites, [1]);
  });

  test('pack without pdf/ never touches the existing pdf/', () async {
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    await host.writeJournal(from: 1, to: 2, swapsPdf: false);
    await recover();
    expectOldPack();
  });

  test('first install killed before the version write keeps no version',
      () async {
    host.version = null;
    host.writeDb('content.db', 'new-db');
    await host.writeJournal(to: 2, swapsPdf: false);
    await recover();
    expect(host.version, isNull);
    expect(host.leftovers(), isEmpty);
  });

  group('without a journal', () {
    test('backup of a missing content.db is restored', () async {
      host.writeDb('content.db.bak', 'old-db');
      host.writePdf('pdf.bak', 'old.pdf');
      await recover();
      expectOldPack();
    });

    test('stale backups next to live files are dropped', () async {
      host.writeDb('content.db', 'old-db');
      host.writeDb('content.db.bak', 'older-db');
      host.writePdf('pdf', 'old.pdf');
      host.writePdf('pdf.bak', 'older.pdf');
      await recover();
      expectOldPack();
    });

    test('an unreadable journal is treated as absent', () async {
      host.writeDb('content.db', 'old-db');
      host.writePdf('pdf', 'old.pdf');
      host.files.journal.writeAsStringSync('{"to":');
      host.files.journalTemp.writeAsStringSync('{');
      await recover();
      expectOldPack();
    });
  });

  test('running recovery twice is safe', () async {
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writeDb('staging/content.db', 'new-db');
    await host.writeJournal(from: 1, to: 2, swapsPdf: false);
    await recover();
    await recover();
    expectOldPack();
    expect(host.versionWrites, isEmpty);
  });
}
