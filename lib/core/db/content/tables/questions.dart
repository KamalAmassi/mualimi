import 'package:drift/drift.dart';

/// `type` is `mcq` or `short`.
@DataClassName('QuestionRow')
class Questions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  TextColumn get type => text()();
  TextColumn get question => text()();
  TextColumn get choicesJson => text().nullable()();
  TextColumn get answer => text()();
}
