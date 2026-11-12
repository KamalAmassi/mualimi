import 'package:drift/drift.dart';

@DataClassName('ChunkRow')
class Chunks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  IntColumn get page => integer()();
  TextColumn get content => text().named('text')();
  TextColumn get textNormalized => text()();
}
