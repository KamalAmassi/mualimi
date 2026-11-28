import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_recovery.dart';

import 'pack_install_fakes.dart';

/// Crash points of the images/ swap, which runs after content.db and pdf/.
void main() {
  late Directory root;
  late TempPackInstallHost host;

  Future<void> recover() => PackRecovery.withHost(host).run();

  void expectPack({required bool isNew}) {
    expect(host.dbMarker(), isNew ? 'new-db' : 'old-db');
    expect(host.exists('pdf/new.pdf'), isNew);
    expect(host.exists('pdf/old.pdf'), !isNew);
    expect(host.exists('images/new.webp'), isNew);
    expect(host.exists('images/old.webp'), !isNew);
    expect(host.version, isNew ? 2 : 1);
    expect(host.leftovers(), isEmpty);
  }

  /// content.db and pdf/ are already swapped, each with its backup.
  void dbAndPdfSwapped() {
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf', 'new.pdf');
    host.writePdf('pdf.bak', 'old.pdf');
  }

  Future<void> journal() => host.writeJournal(from: 1, to: 2, swapsImages: true);

  setUp(() {
    root = Directory.systemTemp.createTempSync('pack_recovery_images_');
    host = TempPackInstallHost(root, version: 1);
    host.packsDir.createSync(recursive: true);
  });

  tearDown(() => root.deleteSync(recursive: true));

  test('killed before images/ was backed up: rolled back', () async {
    dbAndPdfSwapped();
    host.writeImage('images', 'old.webp');
    host.writeImage('staging/images', 'new.webp');
    await journal();
    await recover();
    expectPack(isNew: false);
    expect(host.versionWrites, isEmpty);
  });

  test('killed after images/ was backed up: images.bak is restored', () async {
    dbAndPdfSwapped();
    host.writeImage('images.bak', 'old.webp');
    host.writeImage('staging/images', 'new.webp');
    await journal();
    await recover();
    expectPack(isNew: false);
  });

  test('killed before the version write: new images are replaced', () async {
    dbAndPdfSwapped();
    host.writeImage('images', 'new.webp');
    host.writeImage('images.bak', 'old.webp');
    await journal();
    await recover();
    expectPack(isNew: false);
  });

  test('version stored before images/ was placed: version is restored', () async {
    host.version = 2;
    dbAndPdfSwapped();
    host.writeImage('images.bak', 'old.webp');
    host.writeImage('staging/images', 'new.webp');
    await journal();
    await recover();
    expectPack(isNew: false);
    expect(host.versionWrites, [1]);
  });

  test('killed after the version write: new images are kept', () async {
    host.version = 2;
    dbAndPdfSwapped();
    host.writeImage('images', 'new.webp');
    host.writeImage('images.bak', 'old.webp');
    await journal();
    await recover();
    expectPack(isNew: true);
    expect(host.versionWrites, isEmpty);
  });

  group('without a journal', () {
    test('backup of a missing images/ is restored', () async {
      host.writeDb('content.db', 'old-db');
      host.writePdf('pdf', 'old.pdf');
      host.writeImage('images.bak', 'old.webp');
      await recover();
      expectPack(isNew: false);
    });

    test('a stale images.bak next to images/ is dropped', () async {
      host.writeDb('content.db', 'old-db');
      host.writePdf('pdf', 'old.pdf');
      host.writeImage('images', 'old.webp');
      host.writeImage('images.bak', 'older.webp');
      await recover();
      expectPack(isNew: false);
      expect(host.exists('images/older.webp'), isFalse);
    });
  });

  test('a journal written before swapsImages existed still recovers', () async {
    host.writeDb('content.db', 'new-db');
    host.writeDb('content.db.bak', 'old-db');
    host.writePdf('pdf.bak', 'old.pdf');
    host.writePdf('staging/pdf', 'new.pdf');
    host.writeImage('images', 'old.webp');
    host.files.journal.writeAsStringSync('{"from":1,"to":2,"swapsPdf":true}');
    await recover();
    expectPack(isNew: false);
  });

  test('a non-boolean swapsImages makes the journal unreadable', () async {
    host.writeDb('content.db', 'old-db');
    host.writePdf('pdf', 'old.pdf');
    host.writeImage('images', 'old.webp');
    host.files.journal
        .writeAsStringSync('{"from":1,"to":2,"swapsPdf":true,"swapsImages":1}');
    await recover();
    expectPack(isNew: false);
  });

  test('running recovery twice is safe', () async {
    dbAndPdfSwapped();
    host.writeImage('images.bak', 'old.webp');
    host.writeImage('staging/images', 'new.webp');
    await journal();
    await recover();
    await recover();
    expectPack(isNew: false);
    expect(host.versionWrites, isEmpty);
  });
}
