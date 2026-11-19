import 'package:drift/drift.dart';

/// Maps every PDF page of a subject to the number printed on that page.
@DataClassName('PackPageRow')
class PackPages extends Table {
  TextColumn get subjectId => text()();
  IntColumn get pdfPage => integer()();
  TextColumn get printedPage => text()();

  @override
  Set<Column> get primaryKey => {subjectId, pdfPage};
}
