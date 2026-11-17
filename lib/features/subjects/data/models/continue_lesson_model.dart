import '../../../../core/db/content/content_database.dart';
import '../../domain/entities/continue_lesson.dart';

class ContinueLessonModel extends ContinueLesson {
  const ContinueLessonModel({
    required super.lessonId,
    required super.lessonTitle,
    required super.subjectId,
    required super.subjectName,
    required super.unitTitle,
  });

  factory ContinueLessonModel.fromRows(LessonRow lesson, SubjectRow subject, UnitRow unit) =>
      ContinueLessonModel(
        lessonId: lesson.id,
        lessonTitle: lesson.title,
        subjectId: subject.id,
        subjectName: subject.name,
        unitTitle: unit.title,
      );
}
