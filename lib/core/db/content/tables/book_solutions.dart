import 'package:drift/drift.dart';

@DataClassName('BookSolutionRow')
class BookSolutions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  IntColumn get number => integer()();
  TextColumn get question => text()();
  IntColumn get page => integer()();
  TextColumn get solution => text()();
}
