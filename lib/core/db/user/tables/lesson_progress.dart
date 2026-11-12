import 'package:drift/drift.dart';

/// One row per lesson; the most recently updated row is the "last lesson".
@DataClassName('LessonProgressRow')
class LessonProgress extends Table {
  TextColumn get lessonId => text()();
  IntColumn get lastSection => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {lessonId};
}
