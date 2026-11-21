import '../../../../core/db/content/content_database.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_section.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.subjectId,
    required super.title,
    required super.tutorEnabled,
    required super.sections,
    super.videoUrl,
    super.videoChaptersJson,
    super.bookPagesFrom,
    super.bookPagesTo,
    super.pdfFile,
    super.subjectName,
    super.unitTitle,
  });

  factory LessonModel.fromRows(
    LessonRow row,
    List<SectionRow> sections, {
    String? subjectName,
    String? unitTitle,
  }) =>
      LessonModel(
        id: row.id,
        subjectId: row.subjectId,
        title: row.title,
        tutorEnabled: row.tutorEnabled,
        videoUrl: row.videoUrl,
        videoChaptersJson: row.videoChaptersJson,
        bookPagesFrom: row.bookPagesFrom,
        bookPagesTo: row.bookPagesTo,
        pdfFile: row.pdfFile,
        subjectName: subjectName,
        unitTitle: unitTitle,
        sections: [
          for (final s in sections) LessonSection(id: s.id, title: s.title, body: s.body),
        ],
      );
}
