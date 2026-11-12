import 'package:drift/drift.dart';

@DataClassName('UnitRow')
class Units extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
