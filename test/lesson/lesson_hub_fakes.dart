import 'package:dartz/dartz.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/lesson/domain/entities/book_solution.dart';
import 'package:mualimi/features/lesson/domain/entities/key_term.dart';
import 'package:mualimi/features/lesson/domain/entities/lesson.dart';
import 'package:mualimi/features/lesson/domain/entities/lesson_section.dart';
import 'package:mualimi/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_key_terms_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_lesson_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import 'package:mualimi/features/lesson/presentation/controllers/lesson_controller.dart';

import 'viewer_fakes.dart';

const hubLessonId = 'science-7-u2-l3';
const hubSubjectId = 'science-7';

Lesson hubLesson({
  int sections = 4,
  bool tutorEnabled = true,
  String? pdfFile = 'science-7.pdf',
  int? pagesFrom = 44,
  int? pagesTo = 49,
  String title = 'Charging',
}) =>
    Lesson(
      id: hubLessonId,
      subjectId: hubSubjectId,
      title: title,
      tutorEnabled: tutorEnabled,
      sections: [
        for (var i = 0; i < sections; i++)
          LessonSection(id: i + 1, title: 'Section ${i + 1}', body: 'Body ${i + 1}'),
      ],
      pdfFile: pdfFile,
      bookPagesFrom: pagesFrom,
      bookPagesTo: pagesTo,
      subjectName: 'Science',
      unitTitle: 'Unit 2',
    );

List<KeyTerm> hubTerms(int count) => [
      for (var i = 0; i < count; i++) KeyTerm(term: 'Term ${i + 1}', definition: 'Meaning ${i + 1}'),
    ];

class FakeHubLessonRepository implements LessonRepository {
  FakeHubLessonRepository({Lesson? lesson, List<KeyTerm>? terms, this.fails = false})
      : lesson = lesson ?? hubLesson(),
        terms = terms ?? hubTerms(5);

  Lesson lesson;
  List<KeyTerm> terms;
  bool fails;
  bool termsFail = false;
  final requestedTerms = <String>[];

  @override
  Future<Either<Failure, Lesson>> getLesson(String id) async =>
      fails ? const Left(DatabaseFailure('broken')) : Right(lesson);

  @override
  Future<Either<Failure, List<KeyTerm>>> getKeyTerms(String lessonId) async {
    requestedTerms.add(lessonId);
    return termsFail ? const Left(DatabaseFailure('broken')) : Right(terms);
  }

  @override
  Future<Either<Failure, List<BookSolution>>> getSolutions(String lessonId) async =>
      const Right([]);

  @override
  Future<int> getLastSection(String lessonId) async => 0;

  @override
  Future<void> saveProgress(String lessonId, int section) async {}
}

LessonController lessonController(
  FakeHubLessonRepository lessons, {
  bool subjectTutorEnabled = true,
}) =>
    LessonController(
      GetLessonUseCase(lessons),
      GetKeyTermsUseCase(lessons),
      IsLessonTutorEnabledUseCase(FakeSubjectTutorRepository(enabled: subjectTutorEnabled)),
    );
