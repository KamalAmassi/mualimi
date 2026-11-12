import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_files.dart';

/// All app files live in internal app storage only (never the SD card).
class AppPathsService extends GetxService {
  AppPathsService({Directory? rootOverride}) : _rootOverride = rootOverride;

  final Directory? _rootOverride;
  late final Directory root;

  Future<AppPathsService> init() async {
    root = _rootOverride ?? await getApplicationSupportDirectory();
    for (final dir in [packsDir, modelsDir]) {
      await dir.create(recursive: true);
    }
    return this;
  }

  Directory get packsDir => Directory(p.join(root.path, AppFiles.packsDir));
  Directory get modelsDir => Directory(p.join(root.path, AppFiles.modelsDir));

  File get contentDbFile => File(p.join(packsDir.path, AppFiles.contentDb));
  File get tempContentDbFile => File(p.join(packsDir.path, AppFiles.tempContentDb));
  File get userDbFile => File(p.join(root.path, AppFiles.userDb));
  File get settingsFile => File(p.join(root.path, AppFiles.settingsFile));
  File get manifestCacheFile => File(p.join(root.path, AppFiles.manifestCacheFile));

  File modelFile(String fileName) => File(p.join(modelsDir.path, fileName));
  File pdfFile(String fileName) =>
      File(p.join(packsDir.path, AppFiles.pdfDir, fileName));

  /// Folder holding the in-progress parts of one artifact (model, embedding, pack).
  Directory partsDirOf(String artifactId) =>
      Directory(p.join(modelsDir.path, AppFiles.partsDir, artifactId));
}
