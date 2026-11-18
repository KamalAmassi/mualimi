import 'package:drift/drift.dart';

@DataClassName('LessonRow')
class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get unitId => text()();
  TextColumn get subjectId => text()();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get videoChaptersJson => text().nullable()();
  IntColumn get bookPagesFrom => integer().nullable()();
  IntColumn get bookPagesTo => integer().nullable()();
  IntColumn get pdfPageFrom => integer().nullable()();
  IntColumn get pdfPageTo => integer().nullable()();
  IntColumn get printedPageFrom => integer().nullable()();
  IntColumn get printedPageTo => integer().nullable()();
  TextColumn get pdfFile => text().nullable()();
  BoolColumn get tutorEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
