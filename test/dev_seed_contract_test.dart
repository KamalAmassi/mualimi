import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';

void main() {
  late ContentDatabase db;

  setUp(() async {
    db = ContentDatabase(NativeDatabase.memory());
    await DevSeedScienceG9.insert(db);
  });

  tearDown(() => db.close());

  test('pack_meta carries the schema version of the app and the pack facts',
      () async {
    final meta = {
      for (final r in await db.select(db.packMeta).get()) r.key: r.value
    };
    expect(meta['schema_version'], '${ContentDatabase.packSchemaVersion}');
    expect(meta['grade'], '9');
    expect(meta['pack_version'], '1');
    expect(DateTime.tryParse(meta['built_at'] ?? ''), isNotNull);
  });

  test('every chunk page and lesson range agrees with pack_pages', () async {
    final pages = {
      for (final p in await db.select(db.packPages).get())
        p.pdfPage: p.printedPage
    };
    for (final c in await db.select(db.chunks).get()) {
      expect(pages[c.pdfPage], c.printedPage);
    }
    for (final l in await db.select(db.lessons).get()) {
      if (l.pdfPageFrom == null) continue;
      expect(pages[l.pdfPageFrom], '${l.printedPageFrom}');
      expect(pages[l.pdfPageTo], '${l.printedPageTo}');
    }
  });

  test('the page offset is not fixed', () async {
    final chunks = await db.select(db.chunks).get();
    final offsets = {
      for (final c in chunks) c.pdfPage - int.parse(c.printedPage)
    };
    expect(offsets.length, greaterThan(1));
  });

  test('section bodies use every element of the format', () async {
    final bodies =
        (await db.select(db.sections).get()).map((s) => s.body).join('\n');
    expect(bodies, contains('\n## '));
    expect(bodies, contains('### '));
    expect(bodies, contains('\n- '));
    expect(bodies, contains('**'));
    expect(bodies, contains('> **تذكّر:**'));
    expect(bodies, contains('> **انتبه:**'));
    expect(bodies, matches(RegExp(r'[^$]\$[^$\n]+\$[^$]')));
    expect(bodies, matches(RegExp(r'\$\$\n?[^$]+\n?\$\$')));
    expect(bodies, contains('|---|'));
  });

  test('solutions carry the textbook question', () async {
    final rows = await db.select(db.bookSolutions).get();
    expect(rows, isNotEmpty);
    expect(rows.every((r) => r.question.isNotEmpty), isTrue);
  });

  test('video chapters are ordered by start time', () async {
    final json = (await db.select(db.lessons).get())
        .firstWhere((l) => l.videoChaptersJson != null)
        .videoChaptersJson!;
    final starts = [
      for (final c in jsonDecode(json) as List) c['start_seconds'] as int
    ];
    expect(starts.length, inInclusiveRange(3, 4));
    expect(starts, [...starts]..sort());
  });
}
