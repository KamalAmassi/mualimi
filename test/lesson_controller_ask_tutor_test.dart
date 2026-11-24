import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/routes/app_routes.dart';
import 'package:mualimi/features/curriculum_tutor/presentation/routes/tutor_args.dart';
import 'package:mualimi/features/lesson/domain/entities/lesson.dart';
import 'package:mualimi/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_key_terms_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_last_section_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_lesson_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/is_lesson_tutor_enabled_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/save_lesson_progress_usecase.dart';
import 'package:mualimi/features/lesson/presentation/controllers/lesson_controller.dart';

import 'lesson/viewer_fakes.dart';

class _UnusedLessonRepository implements LessonRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _lesson = Lesson(
  id: 'math-7-u1-l2',
  subjectId: 'math-7',
  title: 'title',
  tutorEnabled: true,
  sections: [],
);

LessonController _controller() {
  final repository = _UnusedLessonRepository();
  return LessonController(
    GetLessonUseCase(repository),
    GetKeyTermsUseCase(repository),
    IsLessonTutorEnabledUseCase(FakeSubjectTutorRepository()),
    GetLastSectionUseCase(repository),
    SaveLessonProgressUseCase(repository),
  );
}

Future<List<Object?>> _pumpApp(WidgetTester tester) async {
  final captured = <Object?>[];
  await tester.pumpWidget(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const SizedBox()),
      GetPage(
        name: AppRoutes.tutor,
        page: () {
          captured.add(Get.arguments);
          return const SizedBox();
        },
      ),
    ],
  ));
  return captured;
}

void main() {
  tearDown(Get.reset);

  testWidgets('askTutor opens the tutor route with the lesson subject and id', (tester) async {
    final captured = await _pumpApp(tester);
    final controller = _controller()
      ..lesson.value = _lesson
      ..tutorEnabled.value = true;

    controller.askTutor();
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.tutor);
    expect(captured.single, const TutorArgs(subjectId: 'math-7', lessonId: 'math-7-u1-l2'));
  });

  testWidgets('askTutor does nothing while the lesson is not loaded', (tester) async {
    final captured = await _pumpApp(tester);
    final controller = _controller();

    controller.askTutor();
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/');
    expect(captured, isEmpty);
  });

  testWidgets('askTutor does nothing when the tutor is disabled', (tester) async {
    final captured = await _pumpApp(tester);
    final controller = _controller()..lesson.value = _lesson;

    controller.askTutor();
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/');
    expect(captured, isEmpty);
  });
}
