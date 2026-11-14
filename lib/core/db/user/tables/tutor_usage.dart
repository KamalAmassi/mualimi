import 'package:drift/drift.dart';

/// Questions sent to the cloud tutor per day. `day` is `yyyy-MM-dd`.
@DataClassName('TutorUsageRow')
class TutorUsage extends Table {
  TextColumn get day => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {day};
}
