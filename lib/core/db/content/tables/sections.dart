import 'package:drift/drift.dart';

@DataClassName('SectionRow')
class Sections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
