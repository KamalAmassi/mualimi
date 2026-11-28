import 'dart:async';
import 'dart:io';

import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_install_files.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_install_host.dart';
import 'package:mualimi/features/content_manager/data/datasources/pack_install_journal.dart';
import 'package:path/path.dart' as p;

import '../helpers/content_db_fixture.dart';

/// Temp-folder host whose "stored" version lives in memory. When [hangOnVersion]
/// is set, the version write stops forever, before or after storing the value,
/// to stand in for the app being killed at that point.
class TempPackInstallHost implements PackInstallHost {
  TempPackInstallHost(this.root, {this.version});

  final Directory root;
  int? version;
  final versionWrites = <int?>[];
  ({bool storeFirst})? hangOnVersion;
  final versionReached = Completer<void>();

  PackInstallFiles get files => PackInstallFiles(this);

  @override
  Directory get packsDir => Directory(p.join(root.path, 'packs'));
  @override
  File get contentDbFile => File(p.join(packsDir.path, 'content.db'));
  @override
  Directory get pdfDir => Directory(p.join(packsDir.path, 'pdf'));
  @override
  Future<void> closeContent() async {}
  @override
  void openContent() {}
  @override
  int? get installedVersion => version;

  @override
  Future<void> setInstalledVersion(int? v) {
    final hang = hangOnVersion;
    if (hang == null || hang.storeFirst) {
      versionWrites.add(v);
      version = v;
    }
    if (hang == null) return Future.value();
    versionReached.complete();
    return Completer<void>().future;
  }

  String path(String rel) => p.join(packsDir.path, rel);

  bool exists(String rel) =>
      FileSystemEntity.typeSync(path(rel)) != FileSystemEntityType.notFound;

  void writeDb(String rel, String marker) =>
      writeContentDb(path(rel),
          schemaVersion: '${ContentDatabase.packSchemaVersion}', marker: marker);

  String dbMarker([String rel = 'content.db']) => contentDbMarker(path(rel));

  void writePdf(String dirRel, String name) =>
      File(p.join(path(dirRel), name)).createSync(recursive: true);

  void writeImage(String dirRel, String name) => writePdf(dirRel, name);

  Future<void> writeJournal({
    int? from,
    required int to,
    bool swapsPdf = true,
    bool swapsImages = false,
  }) =>
      PackInstallJournal(
        from: from,
        to: to,
        swapsPdf: swapsPdf,
        swapsImages: swapsImages,
      ).writeTo(files.journal, files.journalTemp);

  /// Leftovers no finished install or recovery may leave behind.
  List<String> leftovers() => [
        'staging',
        'content.db.bak',
        'pdf.bak',
        'images.bak',
        'install_journal.json',
        'install_journal.json.tmp',
      ].where(exists).toList();
}
