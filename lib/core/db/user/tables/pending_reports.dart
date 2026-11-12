import 'package:drift/drift.dart';

/// Reports wait here until the device is online.
@DataClassName('PendingReportRow')
class PendingReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get reason => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
