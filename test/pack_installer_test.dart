import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_install_host.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_installer.dart';
import 'package:path/path.dart' as p;

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

void main() {
  late Directory root;
  late _FakeHost host;
  late File userDb;
  late File zip;

  String read(String rel) => File(p.join(host.packsDir.path, rel)).readAsStringSync();
  bool exists(String rel) =>
      FileSystemEntity.typeSync(p.join(host.packsDir.path, rel)) !=
      FileSystemEntityType.notFound;

  File writeZip(Map<String, String> files) {
    final archive = Archive();
    files.forEach((name, text) => archive.addFile(ArchiveFile.string(name, text)));
    return File(p.join(host.packsDir.path, 'pack.zip'))
      ..writeAsBytesSync(ZipEncoder().encode(archive));
  }

  setUp(() {
    root = Directory.systemTemp.createTempSync('pack_installer_');
    host = _FakeHost(root);
    Directory(p.join(host.pdfDir.path)).createSync(recursive: true);
    host.contentDbFile.writeAsStringSync('old-db');
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
    zip = writeZip({'content.db': 'new-db', 'pdf/new.pdf': 'new-pdf'});
    await PackInstaller.withHost(host).install(zip, 2);

    expect(read('content.db'), 'new-db');
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

    expect(read('content.db'), 'old-db');
    expect(read('pdf/old.pdf'), 'old-pdf');
    expect(host.version, 1);
    expect(host.events, isEmpty); // never closed
    expectCleaned();
  });

  test('rename failure during swap rolls everything back', () async {
    zip = writeZip({'content.db': 'new-db', 'pdf/new.pdf': 'new-pdf'});
    final installer = PackInstaller.withHost(host, rename: (e, newPath) async {
      if (e.path.contains('staging') && newPath == host.pdfDir.path) {
        throw const FileSystemException('simulated rename failure');
      }
      return e.rename(newPath);
    });
    await expectLater(installer.install(zip, 2), throwsA(isA<FileSystemException>()));

    expect(read('content.db'), 'old-db');
    expect(read('pdf/old.pdf'), 'old-pdf');
    expect(exists('pdf/new.pdf'), isFalse);
    expect(exists('content.db.bak'), isFalse);
    expect(exists('pdf.bak'), isFalse);
    expect(host.version, 1);
    expect(host.events, ['close', 'open']);
    expectCleaned();
  });

  test('version write failure restores old files and old version', () async {
    zip = writeZip({'content.db': 'new-db'});
    final failing = _ThrowingVersionHost(root);
    await expectLater(
        PackInstaller.withHost(failing).install(zip, 2), throwsA(isA<StateError>()));

    expect(read('content.db'), 'old-db');
    expect(failing.version, 1);
    expect(failing.events.last, 'open');
    expectCleaned();
  });

  test('pack without pdf/ leaves existing pdf/ untouched', () async {
    zip = writeZip({'content.db': 'new-db'});
    await PackInstaller.withHost(host).install(zip, 2);

    expect(read('content.db'), 'new-db');
    expect(read('pdf/old.pdf'), 'old-pdf');
    expect(host.version, 2);
    expectCleaned();
  });

  test('stale content.db.bak from an earlier crash does not block install', () async {
    File(p.join(host.packsDir.path, 'content.db.bak')).writeAsStringSync('stale');
    Directory(p.join(host.packsDir.path, 'pdf.bak')).createSync();
    zip = writeZip({'content.db': 'new-db', 'pdf/new.pdf': 'new-pdf'});
    await PackInstaller.withHost(host).install(zip, 3);

    expect(read('content.db'), 'new-db');
    expect(host.version, 3);
    expect(exists('content.db.bak'), isFalse);
    expect(exists('pdf.bak'), isFalse);
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
