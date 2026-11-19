import '../../../../core/db/user/user_database.dart' show SkillMasteryRow;
import '../../domain/entities/mastery_source.dart';
import '../../domain/entities/skill_mastery.dart';

class SkillMasteryModel extends SkillMastery {
  SkillMasteryModel.fromRow(SkillMasteryRow row)
      : super(
          skillId: row.skillId,
          score: row.score,
          source: MasterySource.parse(row.source),
          updatedAt: row.updatedAt,
        );
}
