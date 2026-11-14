import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart';

typedef ContentDatabaseProvider = ContentDatabase Function();

/// Reads the open content database, turning "no pack installed" into a
/// [DatabaseException] that repositories can map to a failure.
class ContentAccess {
  const ContentAccess(this._provider);

  final ContentDatabaseProvider _provider;

  ContentDatabase call() {
    try {
      return _provider();
    } on StateError catch (e) {
      throw DatabaseException(e.message);
    }
  }
}
