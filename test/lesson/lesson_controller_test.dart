import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/features/lesson/presentation/widgets/lesson_hub_strings.dart';

import 'lesson_hub_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the lesson, its key terms and the tutor flag', () async {
    final lessons = FakeHubLessonRepository();
    final controller = lessonController(lessons);
    await controller.load();
    expect(controller.lesson.value, hubLesson());
    expect(controller.keyTerms, hubTerms(5));
    expect(controller.tutorEnabled.value, isTrue);
    expect(controller.failure.value, isNull);
    expect(controller.loading.value, isFalse);
    expect(lessons.requestedTerms, [hubLessonId]);
  });

  test('a failed lesson load keeps the failure and no lesson', () async {
    final controller = lessonController(FakeHubLessonRepository(fails: true));
    await controller.load();
    expect(controller.lesson.value, isNull);
    expect(controller.failure.value, isNotNull);
    expect(controller.loading.value, isFalse);
  });

  test('opening the lesson records it once with its saved section', () async {
    final lessons = FakeHubLessonRepository(lastSection: 2);
    await lessonController(lessons).load();
    await pumpEventQueue();
    expect(lessons.saved, [(hubLessonId, 2)]);
  });

  test('opening a lesson with no progress records section 0', () async {
    final lessons = FakeHubLessonRepository();
    await lessonController(lessons).load();
    await pumpEventQueue();
    expect(lessons.saved, [(hubLessonId, 0)]);
  });

  test('a failed lesson load records nothing', () async {
    final lessons = FakeHubLessonRepository(fails: true);
    await lessonController(lessons).load();
    await pumpEventQueue();
    expect(lessons.saved, isEmpty);
  });

  test('a failed progress save leaves the lesson loaded', () async {
    final controller = lessonController(FakeHubLessonRepository(saveFails: true));
    await controller.load();
    await pumpEventQueue();
    expect(controller.lesson.value, hubLesson());
    expect(controller.keyTerms, hubTerms(5));
    expect(controller.failure.value, isNull);
    expect(controller.loading.value, isFalse);
  });

  test('a key terms failure leaves the lesson usable with no terms', () async {
    final controller = lessonController(FakeHubLessonRepository()..termsFail = true);
    await controller.load();
    expect(controller.lesson.value, isNotNull);
    expect(controller.keyTerms, isEmpty);
    expect(controller.failure.value, isNull);
  });

  test('subtitle joins subject, unit and printed pages', () async {
    final controller = lessonController(FakeHubLessonRepository());
    await controller.load();
    expect(controller.pageRange, 'ص 44–49');
    expect(controller.subtitle, LessonHubStrings.join(['Science', 'Unit 2', 'ص 44–49']));
  });

  test('page range handles a single page and a lesson without pages', () async {
    final single = lessonController(
        FakeHubLessonRepository(lesson: hubLesson(pagesFrom: 12, pagesTo: 12)));
    await single.load();
    expect(single.pageRange, 'ص 12');
    final none = lessonController(
        FakeHubLessonRepository(lesson: hubLesson(pagesFrom: null, pagesTo: null)));
    await none.load();
    expect(none.pageRange, isNull);
    expect(none.subtitle, LessonHubStrings.join(['Science', 'Unit 2']));
  });

  test('hasPdf is false for a missing or empty pdf file', () async {
    for (final (file, expected) in [('a.pdf', true), (null, false), ('', false)]) {
      final controller =
          lessonController(FakeHubLessonRepository(lesson: hubLesson(pdfFile: file)));
      await controller.load();
      expect(controller.hasPdf, expected, reason: '$file');
    }
  });

  for (final (lesson, subject, expected) in [
    (true, true, true),
    (true, false, false),
    (false, true, false),
    (false, false, false),
  ]) {
    test('tutor enabled is $expected when lesson=$lesson subject=$subject', () async {
      final controller = lessonController(
        FakeHubLessonRepository(lesson: hubLesson(tutorEnabled: lesson)),
        subjectTutorEnabled: subject,
      );
      await controller.load();
      expect(controller.tutorEnabled.value, expected);
    });
  }

  test('the lesson id survives another page replacing the route parameters', () async {
    addTearDown(() => Get.parameters = {});
    Get.parameters = {'id': hubLessonId};
    final controller = lessonController(FakeHubLessonRepository());
    await controller.load();
    Get.parameters = {'lessonId': hubLessonId, 'tab': 'explanation'};
    expect(controller.lessonId, hubLessonId);
  });

  test('has content with a PDF, sections or key terms, and none without all three', () async {
    for (final (lessons, expected) in [
      (FakeHubLessonRepository(lesson: hubLesson(sections: 0), terms: const []), true),
      (FakeHubLessonRepository(lesson: hubLesson(pdfFile: null), terms: const []), true),
      (FakeHubLessonRepository(lesson: hubLesson(pdfFile: null, sections: 0)), true),
      (FakeHubLessonRepository(lesson: hubLesson(pdfFile: '', sections: 0), terms: const []),
          false),
    ]) {
      final controller = lessonController(lessons);
      await controller.load();
      expect(controller.hasContent, expected);
    }
  });
}
