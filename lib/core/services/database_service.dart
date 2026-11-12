import 'package:get/get.dart';

import '../db/content/content_database.dart';
import '../db/user/user_database.dart';
import 'app_paths_service.dart';

/// Owns both databases. The content DB can be closed and reopened when a
/// pack update replaces its file; the user DB is open for the app's lifetime.
class DatabaseService extends GetxService {
  DatabaseService(this._paths);

  final AppPathsService _paths;
  late final UserDatabase user;
  ContentDatabase? _content;

  Future<DatabaseService> init() async {
    user = UserDatabase.file(_paths.userDbFile);
    if (_paths.contentDbFile.existsSync()) openContent();
    return this;
  }

  bool get hasContent => _content != null;

  ContentDatabase get content {
    final db = _content;
    if (db == null) throw StateError('Content pack is not installed');
    return db;
  }

  void openContent() {
    _content ??= ContentDatabase.readOnly(_paths.contentDbFile);
  }

  Future<void> closeContent() async {
    await _content?.close();
    _content = null;
  }

  @override
  void onClose() {
    _content?.close();
    user.close();
    super.onClose();
  }
}
