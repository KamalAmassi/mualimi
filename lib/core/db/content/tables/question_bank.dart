import 'package:drift/drift.dart';

@DataClassName('QuestionBankRow')
class QuestionBank extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subjectId => text()();
  TextColumn get lessonId => text()();
  TextColumn get question => text()();
  TextColumn get questionNormalized => text()();
  TextColumn get answer => text()();
  TextColumn get printedPage => text()();
}
