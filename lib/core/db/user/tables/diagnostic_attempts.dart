import 'package:drift/drift.dart';

@DataClassName('DiagnosticAttemptRow')
class DiagnosticAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get answersJson => text().withDefault(const Constant('[]'))();
  TextColumn get resultJson => text().nullable()();
}
