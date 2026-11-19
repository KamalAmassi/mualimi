import 'package:drift/drift.dart';

@DataClassName('SkillRow')
class Skills extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  IntColumn get grade => integer()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  TextColumn get miniLesson => text()();
  TextColumn get sourcePrintedPage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
