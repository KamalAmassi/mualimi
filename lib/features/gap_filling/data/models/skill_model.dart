import '../../../../core/db/content/content_database.dart';
import '../../domain/entities/skill.dart';

class SkillModel extends Skill {
  SkillModel.fromRow(SkillRow row)
      : super(
          id: row.id,
          subjectId: row.subjectId,
          grade: row.grade,
          title: row.title,
          summary: row.summary,
          miniLesson: row.miniLesson,
          sourcePrintedPage: row.sourcePrintedPage,
        );
}
