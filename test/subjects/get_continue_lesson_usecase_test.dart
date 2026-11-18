import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/core/error/failures.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/core/usecase/usecase.dart';
import 'package:mualimi/features/subjects/data/datasources/subjects_local_data_source.dart';
import 'package:mualimi/features/subjects/data/repositories/continue_lesson_repository_impl.dart';
import 'package:mualimi/features/subjects/domain/entities/continue_lesson.dart';
import 'package:mualimi/features/subjects/domain/usecases/get_continue_lesson_usecase.dart';

class _Databases extends Fake implements DatabaseService {
  _Databases(this._content, this.user);
  final ContentDatabase? _content;

  @override
  final UserDatabase user;

  @override
  ContentDatabase get content => _content ?? (throw StateError('Content pack is not installed'));
}

void main() {
  late ContentDatabase content;
  late UserDatabase user;
  late GetContinueLessonUseCase useCase;

  Future<void> progress(String lessonId, DateTime at) => user.into(user.lessonProgress).insert(
        LessonProgressCompanion.insert(lessonId: lessonId, updatedAt: Value(at)),
      );

  GetContinueLessonUseCase build(ContentDatabase? db) => GetContinueLessonUseCase(
      ContinueLessonRepositoryImpl(SubjectsLocalDataSource(_Databases(db, user))));

  setUp(() async {
    content = ContentDatabase(NativeDatabase.memory());
    await DevSeedScienceG9.insert(content);
    user = UserDatabase(NativeDatabase.memory());
    useCase = build(content);
  });

  tearDown(() async {
    await content.close();
    await user.close();
  });

  test('no progress gives no lesson', () async {
    final result = await useCase(const NoParams());
    expect(result.getOrElse(() => throw StateError('failed')), isNull);
  });

  test('newest progress wins, with lesson, subject and unit titles joined', () async {
    await progress(DevSeedScienceG9.otherLessonId, DateTime(2026, 1, 1));
    await progress(DevSeedScienceG9.lessonId, DateTime(2026, 3, 1));
    await progress(DevSeedScienceG9.mathLessonId, DateTime(2026, 2, 1));

    final result = await useCase(const NoParams());

    expect(
      result.getOrElse(() => throw StateError('failed'))!.props,
      const ContinueLesson(
        lessonId: DevSeedScienceG9.lessonId,
        lessonTitle: DevSeedScienceG9.lessonTitle,
        subjectId: DevSeedScienceG9.subjectId,
        subjectName: DevSeedScienceG9.subjectName,
        unitTitle: 'الكهرباء الساكنة',
      ).props,
    );
  });

  test('newer progress for a lesson missing from the pack is skipped', () async {
    await progress('removed-lesson', DateTime(2026, 5, 1));
    await progress(DevSeedScienceG9.mathLessonId, DateTime(2026, 2, 1));

    final lesson = (await useCase(const NoParams())).getOrElse(() => null);

    expect(lesson?.lessonId, DevSeedScienceG9.mathLessonId);
    expect(lesson?.subjectName, 'الرياضيات');
    expect(lesson?.unitTitle, 'المعادلات');
  });

  test('only unknown lessons gives no lesson', () async {
    await progress('removed-lesson', DateTime(2026, 5, 1));
    expect((await useCase(const NoParams())).getOrElse(() => throw StateError('failed')), isNull);
  });

  test('a missing content pack is a database failure', () async {
    await progress(DevSeedScienceG9.lessonId, DateTime(2026, 3, 1));
    final result = await build(null)(const NoParams());
    expect(result.fold((f) => f, (_) => null), isA<DatabaseFailure>());
  });
}
