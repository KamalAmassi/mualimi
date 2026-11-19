import 'dart:convert';

import 'package:drift/drift.dart';

import '../content_database.dart';
import 'dev_seed_arabic_skills.dart';
import 'dev_seed_science_g9.dart';
import 'dev_seed_science_skills_charges.dart';
import 'dev_seed_science_skills_measure.dart';
import 'dev_seed_skill.dart';

/// Development data for the gap-filling tables: prerequisite skills, the
/// lessons that need them and their questions. Adds a grade 9 Arabic lesson.
abstract final class DevSeedGapFilling {
  static const arabicSubjectId = 'arabic';
  static const arabicUnitId = 'arabic-9-u1';
  static const arabicLessonId = 'arabic-9-kana';

  static const _skills = [
    atomSkill,
    chargesSkill,
    conductorsSkill,
    unitsSkill,
    graphSkill,
    partsOfSpeechSkill,
    subjectPredicateSkill,
    verbTensesSkill,
  ];

  static const _prerequisites = {
    DevSeedScienceG9.lessonId: [atomSkillId, chargesSkillId, conductorsSkillId],
    DevSeedScienceG9.otherLessonId: [chargesSkillId, unitsSkillId, graphSkillId],
    arabicLessonId: [
      partsOfSpeechSkillId,
      subjectPredicateSkillId,
      verbTensesSkillId,
    ],
  };

  static Future<void> insert(ContentDatabase db) async {
    await db.batch((b) {
      b.insert(
        db.subjects,
        SubjectsCompanion.insert(
            id: arabicSubjectId,
            name: 'اللغة العربية',
            sortOrder: const Value(2)),
      );
      b.insert(db.units,
          UnitsCompanion.insert(id: arabicUnitId, subjectId: arabicSubjectId, title: 'الجملة الاسمية'));
      b.insert(
        db.lessons,
        LessonsCompanion.insert(
          id: arabicLessonId,
          unitId: arabicUnitId,
          subjectId: arabicSubjectId,
          title: 'كان وأخواتها',
          tutorEnabled: const Value(false),
        ),
      );
      for (final skill in _skills) {
        b.insert(
          db.skills,
          SkillsCompanion.insert(
            id: skill.id,
            subjectId: skill.subjectId,
            grade: skill.grade,
            title: skill.title,
            summary: skill.summary,
            miniLesson: skill.miniLesson,
          ),
        );
        _insertQuestions(b, db, skill.id, 'diagnostic', skill.diagnostic);
        _insertQuestions(b, db, skill.id, 'review', skill.review);
      }
      for (final MapEntry(key: lesson, value: skills) in _prerequisites.entries) {
        for (final skillId in skills) {
          b.insert(
            db.lessonPrerequisites,
            LessonPrerequisitesCompanion.insert(lessonId: lesson, skillId: skillId),
          );
        }
      }
    });
  }

  static void _insertQuestions(Batch b, ContentDatabase db, String skillId,
      String kind, List<DevSeedSkillQuestion> questions) {
    for (final (prompt, choices, answer, explanation) in questions) {
      b.insert(
        db.diagnosticQuestions,
        DiagnosticQuestionsCompanion.insert(
          skillId: skillId,
          prompt: prompt,
          choicesJson: jsonEncode(choices),
          answerIndex: answer,
          explanation: explanation,
          kind: kind,
        ),
      );
    }
  }
}
