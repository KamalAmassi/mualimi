import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/downloads_state.dart';
import 'tables/lesson_progress.dart';
import 'tables/pending_reports.dart';
import 'tables/question_history.dart';
import 'tables/saved_answers.dart';

part 'user_database.g.dart';

/// Student data. Read/write, never wiped by pack or model updates.
@DriftDatabase(tables: [
  SavedAnswers,
  QuestionHistory,
  LessonProgress,
  PendingReports,
  DownloadsState,
])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.e);

  UserDatabase.file(File file) : super(NativeDatabase.createInBackground(file));

  @override
  int get schemaVersion => 1;
}
