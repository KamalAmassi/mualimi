import 'package:drift/drift.dart';

@DataClassName('SkillMasteryRow')
class SkillMastery extends Table {
  TextColumn get skillId => text()();
  IntColumn get score => integer()();

  /// `diagnostic` or `review`.
  TextColumn get source => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {skillId};
}
