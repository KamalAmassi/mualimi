import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/diagnostic_attempts.dart';
import 'tables/downloads_state.dart';
import 'tables/lesson_progress.dart';
import 'tables/pending_questions.dart';
import 'tables/pending_reports.dart';
import 'tables/question_history.dart';
import 'tables/saved_answers.dart';
import 'tables/skill_mastery.dart';
import 'tables/tutor_usage.dart';

part 'user_database.g.dart';

/// Student data. Read/write, never wiped by pack or model updates.
@DriftDatabase(tables: [
  SavedAnswers,
  QuestionHistory,
  LessonProgress,
  PendingReports,
  PendingQuestions,
  TutorUsage,
  DownloadsState,
  SkillMastery,
  DiagnosticAttempts,
])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.e);

  UserDatabase.file(File file) : super(NativeDatabase.createInBackground(file));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(pendingQuestions);
            await m.createTable(tutorUsage);
            await m.addColumn(questionHistory, questionHistory.subjectName);
            await m.addColumn(questionHistory, questionHistory.lessonTitle);
            await m.addColumn(questionHistory, questionHistory.printedPage);
            await m.addColumn(questionHistory, questionHistory.pdfPage);
            await m.addColumn(questionHistory, questionHistory.fromBank);
            await m.addColumn(savedAnswers, savedAnswers.subjectName);
            await m.addColumn(savedAnswers, savedAnswers.lessonTitle);
            await m.addColumn(savedAnswers, savedAnswers.printedPage);
            await m.addColumn(savedAnswers, savedAnswers.pdfPage);
            await m.addColumn(savedAnswers, savedAnswers.fromBank);
            await m.addColumn(questionHistory, questionHistory.answer);
            await customStatement(
                'UPDATE saved_answers SET printed_page = CAST(source_page AS TEXT) '
                'WHERE source_page IS NOT NULL');
          }
          if (from < 3) {
            await m.createTable(skillMastery);
            await m.createTable(diagnosticAttempts);
          }
        },
      );
}
