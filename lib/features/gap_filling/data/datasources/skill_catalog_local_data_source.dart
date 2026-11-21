import 'package:drift/drift.dart';

import '../../../../core/db/content/content_database.dart';
import '../../../../core/error/exceptions.dart' as app;
import '../../../../core/services/database_service.dart';
import '../../domain/entities/question_kind.dart';
import '../../domain/entities/skill_need.dart';
import '../models/diagnostic_question_model.dart';
import '../models/skill_model.dart';

class SkillCatalogLocalDataSource {
  SkillCatalogLocalDataSource(this._databases);
  final DatabaseService _databases;

  /// Skills with the number of installed lessons that need them. With
  /// [lessonId] only that lesson's skills are returned; the count still
  /// covers all lessons.
  Future<List<SkillNeed>> needs({String? lessonId}) async {
    final db = _content();
    final rows = await db.select(db.lessonPrerequisites).join([
      innerJoin(db.skills, db.skills.id.equalsExp(db.lessonPrerequisites.skillId)),
      innerJoin(db.lessons, db.lessons.id.equalsExp(db.lessonPrerequisites.lessonId)),
    ]).get();
    final lessonsBySkill = <String, Set<String>>{};
    final skills = <String, SkillModel>{};
    for (final row in rows) {
      final skill = SkillModel.fromRow(row.readTable(db.skills));
      skills[skill.id] = skill;
      lessonsBySkill
          .putIfAbsent(skill.id, () => {})
          .add(row.readTable(db.lessonPrerequisites).lessonId);
    }
    return [
      for (final MapEntry(key: id, value: lessons) in lessonsBySkill.entries)
        if (lessonId == null || lessons.contains(lessonId))
          SkillNeed(skill: skills[id]!, lessonCount: lessons.length),
    ];
  }

  Future<Map<String, String>> subjectNames() async {
    final db = _content();
    final rows = await (db.select(db.subjects)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return {for (final r in rows) r.id: r.name};
  }

  Future<List<DiagnosticQuestionModel>> questions(QuestionKind kind,
      {String? skillId}) async {
    final db = _content();
    final query = db.select(db.diagnosticQuestions)
      ..where((t) => t.kind.equals(kind.name))
      ..orderBy([(t) => OrderingTerm.asc(t.id)]);
    if (skillId != null) query.where((t) => t.skillId.equals(skillId));
    return (await query.get()).map(DiagnosticQuestionModel.fromRow).toList();
  }

  Future<SkillModel> skill(String id) async {
    final db = _content();
    final row = await (db.select(db.skills)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw app.DatabaseException('skill $id not found');
    return SkillModel.fromRow(row);
  }

  ContentDatabase _content() {
    try {
      return _databases.content;
    } on StateError catch (e) {
      throw app.DatabaseException(e.message);
    }
  }
}
