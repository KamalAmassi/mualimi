import '../../../../core/db/content/content_database.dart';
import '../../domain/entities/lesson_summary.dart';

class LessonSummaryModel extends LessonSummary {
  const LessonSummaryModel({required super.id, required super.title, required super.tutorEnabled});

  factory LessonSummaryModel.fromRow(LessonRow row) =>
      LessonSummaryModel(id: row.id, title: row.title, tutorEnabled: row.tutorEnabled);
}
