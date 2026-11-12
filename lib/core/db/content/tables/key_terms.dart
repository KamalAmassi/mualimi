import 'package:drift/drift.dart';

@DataClassName('KeyTermRow')
class KeyTerms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  TextColumn get term => text()();
  TextColumn get definition => text()();
}
