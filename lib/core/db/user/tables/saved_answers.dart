import 'package:drift/drift.dart';

@DataClassName('SavedAnswerRow')
class SavedAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectId => text()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  IntColumn get sourcePage => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
