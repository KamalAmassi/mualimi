import 'package:dartz/dartz.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/lesson/domain/entities/book_solution.dart';
import 'package:mualimi/features/lesson/domain/entities/key_term.dart';
import 'package:mualimi/features/lesson/domain/entities/lesson.dart';
import 'package:mualimi/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_key_terms_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_lesson_usecase.dart';
import 'package:mualimi/features/lesson/presentation/controllers/key_terms_controller.dart';

const keyTermsLessonTitle = 'Charging methods';

final keyTermsLongDefinition = List.filled(40, 'definition words that wrap').join(' ');

final keyTermsSample = [
  const KeyTerm(term: 'Charge', definition: 'Property of matter.'),
  const KeyTerm(term: 'Neutral', definition: 'Equal positive and negative charges.'),
  KeyTerm(term: 'Induction', definition: keyTermsLongDefinition),
];

class FakeKeyTermsRepository implements LessonRepository {
  FakeKeyTermsRepository({List<KeyTerm>? terms, this.termsFailure, this.lessonFailure})
      : terms = terms ?? keyTermsSample;

  final List<KeyTerm> terms;
  final Failure? termsFailure;
  final Failure? lessonFailure;

  @override
  Future<Either<Failure, List<KeyTerm>>> getKeyTerms(String lessonId) async =>
      termsFailure == null ? Right(terms) : Left(termsFailure!);

  @override
  Future<Either<Failure, Lesson>> getLesson(String id) async => lessonFailure == null
      ? Right(Lesson(
          id: id,
          subjectId: 'science',
          title: keyTermsLessonTitle,
          tutorEnabled: true,
          sections: const [],
        ))
      : Left(lessonFailure!);

  @override
  Future<Either<Failure, List<BookSolution>>> getSolutions(String lessonId) async =>
      const Right([]);

  @override
  Future<int> getLastSection(String lessonId) async => 0;

  @override
  Future<void> saveProgress(String lessonId, int section) async {}
}

KeyTermsController keyTermsController(FakeKeyTermsRepository repository) =>
    KeyTermsController(GetKeyTermsUseCase(repository), GetLessonUseCase(repository));
