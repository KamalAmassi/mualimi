import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_install_host.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_installer.dart';
import 'package:path/path.dart' as p;

import 'helpers/content_db_fixture.dart';

/// Temp-folder host that records close/open/version calls in order.
class _FakeHost implements PackInstallHost {
  _FakeHost(this.root);

  final Directory root;
  final events = <String>[];
  int? version = 1;

  @override
  Directory get packsDir => Directory(p.join(root.path, 'packs'));
  @override
  File get contentDbFile => File(p.join(packsDir.path, 'content.db'));
  @override
  Directory get pdfDir => Directory(p.join(packsDir.path, 'pdf'));
  @override
  Future<void> closeContent() async => events.add('close');
  @override
  void openContent() => events.add('open');
  @override
  int? get installedVersion => version;
  @override
  Future<void> setInstalledVersion(int? v) async {
    events.add('version:$v');
    version = v;
  }
}

const _current = ContentDatabase.packSchemaVersion;

void main() {
  late Directory root;
  late _FakeHost host;
  late File userDb;
  late File zip;

  String read(String rel) => File(p.join(host.packsDir.path, rel)).readAsStringSync();
  String dbMarker() => contentDbMarker(host.contentDbFile.path);
  bool exists(String rel) =>
      FileSystemEntity.typeSync(p.join(host.packsDir.path, rel)) !=
      FileSystemEntityType.notFound;

  List<int> packDb({String? schema = '$_current'}) {
    final path = p.join(root.path, 'fixture.db');
    final bytes = writeContentDb(path, schemaVersion: schema, marker: 'new-db').readAsBytesSync();
    File(path).deleteSync();
    return bytes;
  }

  File writeZip(Map<String, Object> files) {
    final archive = Archive();
    files.forEach((name, data) => archive.addFile(data is List<int>
        ? ArchiveFile.bytes(name, data)
        : ArchiveFile.string(name, data as String)));
    return File(p.join(host.packsDir.path, 'pack.zip'))
      ..writeAsBytesSync(ZipEncoder().encode(archive));
  }

  setUp(() {
    root = Directory.systemTemp.createTempSync('pack_installer_');
    host = _FakeHost(root);
    Directory(p.join(host.pdfDir.path)).createSync(recursive: true);
    writeContentDb(host.contentDbFile.path, schemaVersion: '$_current', marker: 'old-db');
    File(p.join(host.pdfDir.path, 'old.pdf')).writeAsStringSync('old-pdf');
    userDb = File(p.join(root.path, 'user.db'))..writeAsStringSync('user-data');
  });

  tearDown(() => root.deleteSync(recursive: true));

  void expectCleaned() {
    expect(exists('staging'), isFalse);
    expect(zip.existsSync(), isFalse);
    expect(userDb.readAsStringSync(), 'user-data');
  }

  test('success swaps db and pdf, writes version, cleans up', () async {
    zip = writeZip({'content.db': packDb(), 'pdf/new.pdf': 'new-pdf'});
    await PackInstaller.withHost(host).install(zip, 2);

    expect(dbMarker(), 'new-db');
    expect(read('pdf/new.pdf'), 'new-pdf');
    expect(exists('pdf/old.pdf'), isFalse);
    expect(host.version, 2);
    expect(host.events, ['close', 'version:2', 'open']);
    expect(exists('content.db.bak'), isFalse);
    expect(exists('pdf.bak'), isFalse);
    expectCleaned();
  });

  test('staging without content.db fails without touching old content', () async {
    zip = writeZip({'readme.txt': 'x'});
    await expectLater(
        PackInstaller.withHost(host).install(zip, 2), throwsA(isA<ManifestException>()));

    expect(dbMarker(), 'old-db');
    expect(read('pdf/old.pdf'), 'old-pdf');
    expect(host.version, 1);
    expect(host.events, isEmpty); // never closed
    expectCleaned();
  });

  test('rename failure during swap rolls everything back', () async {
    zip = writeZip({'content.db': packDb(), 'pdf/new.pdf': 'new-pdf'});
    final installer = PackInstaller.withHost(host, rename: (e, newPath) async {
      if (e.path.contains('staging') && newPath == host.pdfDir.path) {
        throw const FileSystemException('simulated rename failure');
      }
      return e.rename(newPath);
    });
    await expectLater(installer.install(zip, 2), throwsA(isA<FileSystemException>()));

    expect(dbMarker(), 'old-db');
    expect(read('pdf/old.pdf'), 'old-pdf');
    expect(exists('pdf/new.pdf'), isFalse);
    expect(exists('content.db.bak'), isFalse);
    expect(exists('pdf.bak'), isFalse);
    expect(host.version, 1);
    expect(host.events, ['close', 'open']);
    expectCleaned();
  });

  test('version write failure restores old files and old version', () async {
    zip = writeZip({'content.db': packDb()});
    final failing = _ThrowingVersionHost(root);
    await expectLater(
        PackInstaller.withHost(failing).install(zip, 2), throwsA(isA<StateError>()));

    expect(dbMarker(), 'old-db');
    expect(failing.version, 1);
    expect(failing.events.last, 'open');
    expectCleaned();
  });

  test('pack without pdf/ leaves existing pdf/ untouched', () async {
    zip = writeZip({'content.db': packDb()});
    await PackInstaller.withHost(host).install(zip, 2);

    expect(dbMarker(), 'new-db');
    expect(read('pdf/old.pdf'), 'old-pdf');
    expect(host.version, 2);
    expectCleaned();
  });

  test('stale content.db.bak from an earlier crash does not block install', () async {
    File(p.join(host.packsDir.path, 'content.db.bak')).writeAsStringSync('stale');
    Directory(p.join(host.packsDir.path, 'pdf.bak')).createSync();
    zip = writeZip({'content.db': packDb(), 'pdf/new.pdf': 'new-pdf'});
    await PackInstaller.withHost(host).install(zip, 3);

    expect(dbMarker(), 'new-db');
    expect(host.version, 3);
    expect(exists('content.db.bak'), isFalse);
    expect(exists('pdf.bak'), isFalse);
    expectCleaned();
  });

  for (final (label, schema) in [
    ('older', '${_current - 1}'),
    ('newer', '${_current + 1}'),
    ('missing', null),
    ('non-numeric', 'two'),
  ]) {
    test('$label schema_version is rejected and old content is kept', () async {
      zip = writeZip({'content.db': packDb(schema: schema), 'pdf/new.pdf': 'new-pdf'});
      await expectLater(
          PackInstaller.withHost(host).install(zip, 2), throwsA(isA<ManifestException>()));

      expect(dbMarker(), 'old-db');
      expect(read('pdf/old.pdf'), 'old-pdf');
      expect(exists('pdf/new.pdf'), isFalse);
      expect(host.version, 1);
      expect(host.events, isEmpty);
      expectCleaned();
    });
  }

  test('content.db that is not a database is rejected', () async {
    zip = writeZip({'content.db': 'not-a-database'});
    await expectLater(
        PackInstaller.withHost(host).install(zip, 2), throwsA(isA<ManifestException>()));

    expect(dbMarker(), 'old-db');
    expect(host.version, 1);
    expect(host.events, isEmpty);
    expectCleaned();
  });
}

/// Mimics SettingsService: updates memory, then fails to persist.
class _ThrowingVersionHost extends _FakeHost {
  _ThrowingVersionHost(super.root);

  @override
  Future<void> setInstalledVersion(int? v) async {
    events.add('version:$v');
    final first = version != v && v == 2;
    version = v;
    if (first) throw StateError('disk full');
  }
}
