import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_skills_charges.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'gap_filling_harness.dart';

void main() {
  final h = GapFillingHarness();
  setUp(h.open);
  tearDown(h.close);

  test('science has 5 skills from grades 7 and 8, Arabic has 3', () async {
    final skills = await h.content.select(h.content.skills).get();
    final science = skills.where((s) => s.subjectId == 'science');
    expect(science.length, 5);
    expect(science.every((s) => s.grade == 7 || s.grade == 8), isTrue);
    expect(skills.where((s) => s.subjectId == 'arabic').length, 3);
  });

  test('every skill has 2 diagnostic and 2 review questions with 4 choices', () async {
    final skills = await h.content.select(h.content.skills).get();
    final questions = await h.content.select(h.content.diagnosticQuestions).get();
    for (final skill in skills) {
      for (final kind in ['diagnostic', 'review']) {
        final own = questions.where((q) => q.skillId == skill.id && q.kind == kind);
        expect(own.length, 2, reason: '${skill.id} $kind');
        for (final q in own) {
          final choices = jsonDecode(q.choicesJson) as List;
          expect(choices.length, 4);
          expect(q.answerIndex, inInclusiveRange(0, 3));
          expect(q.explanation, isNotEmpty);
        }
      }
    }
  });

  test('mini lessons follow the pack format: subheading, paragraph, list, callout',
      () async {
    for (final skill in await h.content.select(h.content.skills).get()) {
      final body = skill.miniLesson;
      expect(body, startsWith('## '), reason: skill.id);
      expect(body, contains('\n- '), reason: skill.id);
      expect(body, contains('> **تذكّر:**'), reason: skill.id);
      expect(RegExp(r'\n\n[^#>\-\n]').hasMatch(body), isTrue, reason: skill.id);
      expect(skill.summary.contains('\n'), isFalse);
    }
  });

  test('the charging lesson needs the atom and charges skills', () async {
    final rows = await (h.content.select(h.content.lessonPrerequisites)
          ..where((t) => t.lessonId.equals(DevSeedScienceG9.lessonId)))
        .get();
    expect(rows.map((r) => r.skillId), containsAll([atomSkillId, chargesSkillId]));
  });

  test('every prerequisite points at an existing lesson and skill', () async {
    final lessons = {for (final l in await h.content.select(h.content.lessons).get()) l.id};
    final skills = {for (final s in await h.content.select(h.content.skills).get()) s.id};
    for (final p in await h.content.select(h.content.lessonPrerequisites).get()) {
      expect(lessons, contains(p.lessonId));
      expect(skills, contains(p.skillId));
    }
  });

  test('upgrading a user.db from schema 2 creates the new tables and keeps data',
      () async {
    final raw = sqlite.sqlite3.openInMemory();
    raw.execute('PRAGMA user_version = 2');
    raw.execute('CREATE TABLE lesson_progress (lesson_id TEXT NOT NULL PRIMARY KEY, '
        'last_section INTEGER NOT NULL DEFAULT 0, updated_at INTEGER NOT NULL DEFAULT 0)');
    raw.execute("INSERT INTO lesson_progress (lesson_id) VALUES ('kept')");
    final db = UserDatabase(NativeDatabase.opened(raw));
    addTearDown(db.close);

    expect(await db.select(db.skillMastery).get(), isEmpty);
    expect(await db.select(db.diagnosticAttempts).get(), isEmpty);
    expect((await db.select(db.lessonProgress).get()).single.lessonId, 'kept');
  });
}
