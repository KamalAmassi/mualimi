import 'package:drift/drift.dart';

/// `kind` is `explain`, `summary` or `terms`.
@DataClassName('PrebuiltAnswerRow')
class PrebuiltAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  TextColumn get kind => text()();
  TextColumn get content => text()();
}
