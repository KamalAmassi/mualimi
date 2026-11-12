import 'package:drift/drift.dart';

@DataClassName('QuestionHistoryRow')
class QuestionHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectId => text()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get question => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
