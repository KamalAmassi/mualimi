import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/features/subjects/domain/entities/continue_lesson.dart';
import 'package:mualimi/features/subjects/domain/repositories/continue_lesson_repository.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_last_opened_lesson_usecase.dart';

import 'home_fakes.dart';

class _FailingRepository implements ContinueLessonRepository {
  @override
  Future<Either<Failure, ContinueLesson?>> getContinueLesson() async =>
      const Left(DatabaseFailure('closed'));

  @override
  Future<Either<Failure, String?>> getLastOpenedLessonId(String subjectId) async =>
      const Left(DatabaseFailure('closed'));
}

void main() {
  test('returns the last opened lesson of the given subject', () async {
    final useCase = GetLastOpenedLessonUseCase(FakeContinueLessonRepository(null,
        lastOpenedBySubject: {'science': 'charging', 'math': 'solve'}));
    expect(await useCase('science'), const Right<Failure, String?>('charging'));
    expect(await useCase('math'), const Right<Failure, String?>('solve'));
  });

  test('returns null when the subject has no opened lesson', () async {
    final useCase = GetLastOpenedLessonUseCase(FakeContinueLessonRepository(null));
    expect(await useCase('science'), const Right<Failure, String?>(null));
  });

  test('passes a repository failure through', () async {
    final useCase = GetLastOpenedLessonUseCase(_FailingRepository());
    expect((await useCase('science')).isLeft(), isTrue);
  });
}
