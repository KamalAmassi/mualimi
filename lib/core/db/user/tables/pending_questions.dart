import 'package:drift/drift.dart';

/// Questions asked without internet. `chunkIds` is a comma-separated list of
/// the pack passages found for the question; `status` is `pending`,
/// `answered` or `failed`.
@DataClassName('PendingQuestionRow')
class PendingQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get question => text()();
  TextColumn get subjectId => text()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get chunkIds => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get answeredAt => dateTime().nullable()();
}
