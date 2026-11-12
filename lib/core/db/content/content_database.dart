import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'tables/book_solutions.dart';
import 'tables/chunk_vectors.dart';
import 'tables/chunks.dart';
import 'tables/key_terms.dart';
import 'tables/lessons.dart';
import 'tables/pack_meta.dart';
import 'tables/prebuilt_answers.dart';
import 'tables/questions.dart';
import 'tables/sections.dart';
import 'tables/subjects.dart';
import 'tables/units.dart';

part 'content_database.g.dart';

/// Curriculum content. The app never writes to it: updating a pack replaces
/// the whole file. Prebuilt pack files must set `PRAGMA user_version` to
/// [schemaVersion] so opening read-only needs no migration.
@DriftDatabase(tables: [
  Subjects,
  Units,
  Lessons,
  Sections,
  KeyTerms,
  Questions,
  BookSolutions,
  Chunks,
  ChunkVectors,
  PrebuiltAnswers,
  PackMeta,
])
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase(super.e);

  /// Opens an installed pack read-only.
  ContentDatabase.readOnly(File file)
      : super(NativeDatabase.opened(
            sqlite.sqlite3.open(file.path, mode: sqlite.OpenMode.readOnly)));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createSearchIndex();
        },
      );

  // External-content FTS5 index over chunks.text_normalized, kept in sync by triggers.
  Future<void> _createSearchIndex() async {
    await customStatement('CREATE VIRTUAL TABLE chunks_fts USING fts5('
        'text_normalized, content="chunks", content_rowid="id")');
    await customStatement('CREATE TRIGGER chunks_ai AFTER INSERT ON chunks BEGIN '
        'INSERT INTO chunks_fts(rowid, text_normalized) '
        'VALUES (new.id, new.text_normalized); END');
    await customStatement('CREATE TRIGGER chunks_ad AFTER DELETE ON chunks BEGIN '
        'INSERT INTO chunks_fts(chunks_fts, rowid, text_normalized) '
        'VALUES ("delete", old.id, old.text_normalized); END');
  }
}
