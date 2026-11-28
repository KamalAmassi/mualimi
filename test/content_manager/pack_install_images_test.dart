import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_archive_extractor.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_installer.dart';
import 'package:path/path.dart' as p;

import '../helpers/content_db_fixture.dart';
import 'pack_install_fakes.dart';

void main() {
  late Directory root;
  late TempPackInstallHost host;
  late File zip;

  File writeZip(Map<String, String> files, {List<String> dirs = const []}) {
    final dbPath = p.join(root.path, 'fixture.db');
    final db = writeContentDb(dbPath,
        schemaVersion: '${ContentDatabase.packSchemaVersion}', marker: 'new-db');
    final archive = Archive()
      ..addFile(ArchiveFile.bytes('content.db', db.readAsBytesSync()));
    db.deleteSync();
    for (final dir in dirs) {
      archive.addFile(ArchiveFile.directory(dir));
    }
    files.forEach((name, data) => archive.addFile(ArchiveFile.string(name, data)));
    return File(p.join(root.path, 'pack.zip'))
      ..writeAsBytesSync(ZipEncoder().encode(archive));
  }

  Future<void> install() => PackInstaller.withHost(host).install(zip, 2);

  setUp(() {
    root = Directory.systemTemp.createTempSync('pack_install_images_');
    host = TempPackInstallHost(root, version: 1);
    host.writeDb('content.db', 'old-db');
    host.writeImage('images', 'old.webp');
  });

  tearDown(() => root.deleteSync(recursive: true));

  test('images/ is swapped in next to content.db', () async {
    zip = writeZip({'images/fig-1.webp': 'a', 'images/fig-2.webp': 'b'});
    await install();

    expect(host.dbMarker(), 'new-db');
    expect(File(host.path('images/fig-1.webp')).readAsStringSync(), 'a');
    expect(host.exists('images/fig-2.webp'), isTrue);
    expect(host.exists('images/old.webp'), isFalse);
    expect(host.version, 2);
    expect(host.leftovers(), isEmpty);
    expect(zip.existsSync(), isFalse);
  });

  test('a pack without images/ leaves the existing images/ untouched', () async {
    zip = writeZip({});
    await install();

    expect(host.dbMarker(), 'new-db');
    expect(host.exists('images/old.webp'), isTrue);
    expect(host.leftovers(), isEmpty);
  });

  test('an empty images/ replaces the old images', () async {
    zip = writeZip({}, dirs: ['images/']);
    await install();

    expect(Directory(host.path('images')).listSync(), isEmpty);
    expect(host.leftovers(), isEmpty);
  });

  for (final name in [
    'images/sub/a.webp',
    'images/a.png',
    'images/A.WEBP',
    'images/.a.webp',
    'images/../a.webp',
    '../a.webp',
    '/a.webp',
  ]) {
    test('"$name" fails the install before anything is swapped', () async {
      zip = writeZip({name: 'x', 'images/ok.webp': 'ok'});
      await expectLater(install(), throwsA(isA<ManifestException>()));

      expect(host.dbMarker(), 'old-db');
      expect(host.exists('images/old.webp'), isTrue);
      expect(host.exists('images/ok.webp'), isFalse);
      expect(host.version, 1);
      expect(host.versionWrites, isEmpty);
      expect(host.leftovers(), isEmpty);
      expect(zip.existsSync(), isFalse);
      expect(File(p.join(root.path, 'a.webp')).existsSync(), isFalse);
    });
  }

  test('an images/ subfolder entry is rejected', () {
    expect(PackArchiveExtractor.layoutProblem('images/sub/', isFile: false), isNotNull);
    expect(PackArchiveExtractor.layoutProblem('images/', isFile: false), isNull);
  });

  test('a symlink inside images/ is rejected', () {
    expect(PackArchiveExtractor.layoutProblem('images/a.webp', isFile: false), isNotNull);
  });

  test('entries outside images/ keep their names', () {
    for (final name in ['content.db', 'pdf/math.pdf', 'pdf/', 'C.txt']) {
      expect(PackArchiveExtractor.layoutProblem(name, isFile: true), isNull);
    }
    expect(PackArchiveExtractor.layoutProblem('C:/a.webp', isFile: true), isNotNull);
  });

  test('a backslash in an entry name is rejected', () {
    // ZipEncoder rewrites backslashes, so this rule is checked directly.
    expect(PackArchiveExtractor.layoutProblem(r'pdf\a.pdf', isFile: true), isNotNull);
    expect(PackArchiveExtractor.layoutProblem(r'images\a.webp', isFile: true), isNotNull);
  });
}
