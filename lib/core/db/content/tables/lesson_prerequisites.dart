import 'package:drift/drift.dart';

@DataClassName('LessonPrerequisiteRow')
class LessonPrerequisites extends Table {
  TextColumn get lessonId => text()();
  TextColumn get skillId => text()();

  @override
  Set<Column> get primaryKey => {lessonId, skillId};
}
