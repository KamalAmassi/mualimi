import 'package:drift/drift.dart';

/// `printedPage` is the number printed on the book page (shown to students);
/// `pdfPage` is the page index used to open the PDF viewer.
@DataClassName('ChunkRow')
class Chunks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  TextColumn get printedPage => text()();
  IntColumn get pdfPage => integer()();
  TextColumn get content => text().named('text')();
  TextColumn get textNormalized => text()();
}
