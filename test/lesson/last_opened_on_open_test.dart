import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:mualimi/core/db/content/content_database.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/user/user_database.dart';
import 'package:mualimi/core/services/database_service.dart';
import 'package:mualimi/features/lesson/data/datasources/lesson_local_data_source.dart';
import 'package:mualimi/features/lesson/data/datasources/lesson_progress_local_data_source.dart';
import 'package:mualimi/features/lesson/data/repositories/lesson_repository_impl.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_key_terms_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_last_section_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_lesson_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/save_lesson_progress_usecase.dart';
import 'package:mualimi/features/lesson/presentation/controllers/lesson_controller.dart';
import 'package:mualimi/features/subjects/data/datasources/subjects_local_data_source.dart';

import 'viewer_fakes.dart';

class _Databases extends Fake implements DatabaseService {
  _Databases(this.content, this.user);

  @override
  final ContentDatabase content;

  @override
  final UserDatabase user;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContentDatabase content;
  late UserDatabase user;
  late _Databases databases;

  Future<void> progress(String lessonId, int section, DateTime at) =>
      user.into(user.lessonProgress).insert(LessonProgressCompanion.insert(
          lessonId: lessonId, lastSection: Value(section), updatedAt: Value(at)));

  Future<int?> sectionOf(String lessonId) async =>
      (await (user.select(user.lessonProgress)..where((t) => t.lessonId.equals(lessonId)))
              .getSingleOrNull())
          ?.lastSection;

  LessonController hub() {
    final lessons = LessonRepositoryImpl(
      LessonLocalDataSource(databases),
      LessonProgressLocalDataSource(user),
    );
    return LessonController(
      GetLessonUseCase(lessons),
      GetKeyTermsUseCase(lessons),
      IsLessonTutorEnabledUseCase(FakeSubjectTutorRepository()),
      GetLastSectionUseCase(lessons),
      SaveLessonProgressUseCase(lessons),
    );
  }

  setUp(() async {
    content = ContentDatabase(NativeDatabase.memory());
    await DevSeedScienceG9.insert(content);
    user = UserDatabase(NativeDatabase.memory());
    databases = _Databases(content, user);
  });

  tearDown(() async {
    Get.parameters = {};
    await content.close();
    await user.close();
  });

  test('opening lesson B in the hub makes it the last opened lesson', () async {
    await progress(DevSeedScienceG9.lessonId, 3, DateTime(2026, 1, 2));
    await progress(DevSeedScienceG9.otherLessonId, 1, DateTime(2026, 1, 1));
    final subjects = SubjectsLocalDataSource(databases);
    expect((await subjects.continueLesson())?.lessonId, DevSeedScienceG9.lessonId);

    Get.parameters = {'id': DevSeedScienceG9.otherLessonId};
    await hub().load();
    await pumpEventQueue();

    expect((await subjects.continueLesson())?.lessonId, DevSeedScienceG9.otherLessonId);
    expect(await subjects.lastOpenedLessonId(DevSeedScienceG9.subjectId),
        DevSeedScienceG9.otherLessonId);
    expect(await sectionOf(DevSeedScienceG9.otherLessonId), 1);
    expect(await sectionOf(DevSeedScienceG9.lessonId), 3);
  });
}
