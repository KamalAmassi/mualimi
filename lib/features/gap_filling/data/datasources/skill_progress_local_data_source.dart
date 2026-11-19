import 'package:drift/drift.dart';

import '../../../../core/db/user/user_database.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/entities/diagnostic_answer.dart';
import '../../domain/entities/skill_mastery.dart' as domain;
import '../models/diagnostic_attempt_model.dart';
import '../models/skill_mastery_model.dart';

class SkillProgressLocalDataSource {
  SkillProgressLocalDataSource(this._databases);
  final DatabaseService _databases;

  UserDatabase get _user => _databases.user;

  Future<List<SkillMasteryModel>> mastery() async =>
      (await _user.select(_user.skillMastery).get())
          .map(SkillMasteryModel.fromRow)
          .toList();

  Future<void> saveMastery(domain.SkillMastery m) =>
      _user.into(_user.skillMastery).insertOnConflictUpdate(_companion(m));

  Future<bool> hasFinishedDiagnostic() async {
    final finished = await (_user.select(_user.diagnosticAttempts)
          ..where((t) => t.finishedAt.isNotNull())
          ..limit(1))
        .get();
    return finished.isNotEmpty;
  }

  Future<List<DiagnosticAttemptModel>> unfinishedAttempts() async =>
      (await (_user.select(_user.diagnosticAttempts)
                ..where((t) => t.finishedAt.isNull())
                ..orderBy([(t) => OrderingTerm.asc(t.id)]))
              .get())
          .map(DiagnosticAttemptModel.fromRow)
          .toList();

  Future<DiagnosticAttemptModel> startAttempt(
      String subjectId, DateTime startedAt) async {
    final id = await _user.into(_user.diagnosticAttempts).insert(
        DiagnosticAttemptsCompanion.insert(
            subjectId: subjectId, startedAt: startedAt));
    final row = await (_user.select(_user.diagnosticAttempts)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return DiagnosticAttemptModel.fromRow(row);
  }

  Future<void> saveAnswers(int attemptId, List<DiagnosticAnswer> answers) =>
      (_user.update(_user.diagnosticAttempts)
            ..where((t) => t.id.equals(attemptId)))
          .write(DiagnosticAttemptsCompanion(
              answersJson: Value(DiagnosticAttemptModel.encodeAnswers(answers))));

  Future<void> completeAttempt({
    required int attemptId,
    required DateTime finishedAt,
    required List<DiagnosticAnswer> answers,
    required String resultJson,
    required List<String> skillIds,
    required List<domain.SkillMastery> mastery,
  }) =>
      _user.transaction(() async {
        await (_user.delete(_user.skillMastery)
              ..where((t) => t.skillId.isIn(skillIds)))
            .go();
        await _user.batch((b) => b.insertAll(
            _user.skillMastery, [for (final m in mastery) _companion(m)]));
        await (_user.update(_user.diagnosticAttempts)
              ..where((t) => t.id.equals(attemptId)))
            .write(DiagnosticAttemptsCompanion(
          finishedAt: Value(finishedAt),
          answersJson: Value(DiagnosticAttemptModel.encodeAnswers(answers)),
          resultJson: Value(resultJson),
        ));
      });

  SkillMasteryCompanion _companion(domain.SkillMastery m) =>
      SkillMasteryCompanion.insert(
        skillId: m.skillId,
        score: m.score,
        source: m.source.name,
        updatedAt: Value(m.updatedAt),
      );
}
