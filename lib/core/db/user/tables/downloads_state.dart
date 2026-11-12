import 'package:drift/drift.dart';

/// Persists download progress per file part so downloads survive restarts.
/// `id` looks like `model:0` (artifact id : part index).
@DataClassName('DownloadStateRow')
class DownloadsState extends Table {
  TextColumn get id => text()();
  TextColumn get artifact => text()();
  IntColumn get partIndex => integer()();
  TextColumn get status => text()();
  IntColumn get bytesDownloaded => integer().withDefault(const Constant(0))();
  IntColumn get totalBytes => integer().withDefault(const Constant(0))();
  TextColumn get taskId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
