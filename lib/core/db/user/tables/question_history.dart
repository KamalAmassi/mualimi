import 'package:drift/drift.dart';

@DataClassName('QuestionHistoryRow')
class QuestionHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectId => text()();
  TextColumn get subjectName => text().withDefault(const Constant(''))();
  TextColumn get lessonId => text().nullable()();
  TextColumn get lessonTitle => text().nullable()();
  TextColumn get question => text()();
  TextColumn get answer => text().withDefault(const Constant(''))();
  TextColumn get printedPage => text().nullable()();
  IntColumn get pdfPage => integer().nullable()();
  BoolColumn get fromBank => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
