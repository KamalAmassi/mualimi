import 'package:drift/drift.dart';

@DataClassName('DiagnosticQuestionRow')
class DiagnosticQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get skillId => text()();
  TextColumn get prompt => text()();
  TextColumn get choicesJson => text()();
  IntColumn get answerIndex => integer()();
  TextColumn get explanation => text()();

  /// `diagnostic` or `review`.
  TextColumn get kind => text()();
}
