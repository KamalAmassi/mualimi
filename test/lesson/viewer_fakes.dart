import 'package:dartz/dartz.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/lesson/domain/entities/book_solution.dart';
import 'package:mualimi/features/lesson/domain/entities/key_term.dart';
import 'package:mualimi/features/lesson/domain/entities/lesson.dart';
import 'package:mualimi/features/lesson/domain/entities/lesson_section.dart';
import 'package:mualimi/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:mualimi/features/lesson/domain/repositories/reading_preferences_repository.dart';
import 'package:mualimi/features/lesson/domain/repositories/subject_tutor_repository.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_book_solutions_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_font_scale_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_last_section_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_lesson_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/save_font_scale_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/save_lesson_progress_usecase.dart';
import 'package:mualimi/features/lesson/presentation/controllers/viewer_controller.dart';

const viewerLessonId = 'lesson-1';
const viewerSubjectId = 'science';

Lesson viewerLesson({int sections = 4, bool tutorEnabled = true, String body = 'Body'}) => Lesson(
      id: viewerLessonId,
      subjectId: viewerSubjectId,
      title: 'Charging',
      tutorEnabled: tutorEnabled,
      sections: [
        for (var i = 0; i < sections; i++)
          LessonSection(id: i + 1, title: 'Section ${i + 1}', body: '$body ${i + 1}'),
      ],
    );

class FakeViewerLessonRepository implements LessonRepository {
  FakeViewerLessonRepository({Lesson? lesson, this.lastSection = 0, this.fails = false})
      : lesson = lesson ?? viewerLesson();

  Lesson lesson;
  int lastSection;
  bool fails;
  final saved = <(String, int)>[];
  final requested = <String>[];

  @override
  Future<Either<Failure, Lesson>> getLesson(String id) async {
    requested.add(id);
    return fails ? const Left(DatabaseFailure('broken')) : Right(lesson);
  }

  @override
  Future<Either<Failure, List<BookSolution>>> getSolutions(String lessonId) async =>
      const Right([]);

  @override
  Future<Either<Failure, List<KeyTerm>>> getKeyTerms(String lessonId) async => const Right([]);

  @override
  Future<int> getLastSection(String lessonId) async => lastSection;

  @override
  Future<void> saveProgress(String lessonId, int section) async => saved.add((lessonId, section));
}

class FakeReadingPreferences implements ReadingPreferencesRepository {
  FakeReadingPreferences([this.fontScale = 1.0]);

  @override
  double fontScale;

  @override
  Future<void> saveFontScale(double scale) async => fontScale = scale;
}

class FakeSubjectTutorRepository implements SubjectTutorRepository {
  FakeSubjectTutorRepository({this.enabled = true});
  final bool enabled;

  @override
  Future<bool> isTutorEnabled(String subjectId) async => enabled;
}

ViewerController viewerController(
  FakeViewerLessonRepository lessons, {
  ReadingPreferencesRepository? preferences,
  bool subjectTutorEnabled = true,
}) {
  final prefs = preferences ?? FakeReadingPreferences();
  return ViewerController(
    GetLessonUseCase(lessons),
    GetBookSolutionsUseCase(lessons),
    GetLastSectionUseCase(lessons),
    SaveLessonProgressUseCase(lessons),
    GetFontScaleUseCase(prefs),
    SaveFontScaleUseCase(prefs),
    IsLessonTutorEnabledUseCase(FakeSubjectTutorRepository(enabled: subjectTutorEnabled)),
  );
}
