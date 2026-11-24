import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'viewer_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('opens at the saved section without saving progress', () async {
    final lessons = FakeViewerLessonRepository(lastSection: 2);
    final controller = viewerController(lessons);
    await controller.load();
    expect(controller.sectionIndex.value, 2);
    expect(controller.currentSection?.title, 'Section 3');
    expect(controller.loading.value, isFalse);
    expect(lessons.saved, isEmpty);
  });

  test('a saved section past the end opens at the last section', () async {
    final controller = viewerController(FakeViewerLessonRepository(lastSection: 9));
    await controller.load();
    expect(controller.sectionIndex.value, 3);
  });

  test('previous and next stay within bounds and save each change', () async {
    final lessons = FakeViewerLessonRepository();
    final controller = viewerController(lessons);
    await controller.load();
    expect(controller.canGoPrevious, isFalse);
    await controller.goToPrevious();
    expect(controller.sectionIndex.value, 0);
    for (var i = 0; i < 4; i++) {
      await controller.goToNext();
    }
    expect(controller.sectionIndex.value, 3);
    expect(controller.canGoNext, isFalse);
    await controller.goToPrevious();
    expect(controller.sectionIndex.value, 2);
    expect(lessons.saved, [
      (viewerLessonId, 1),
      (viewerLessonId, 2),
      (viewerLessonId, 3),
      (viewerLessonId, 2),
    ]);
  });

  test('a single-section lesson can move neither way', () async {
    final lessons = FakeViewerLessonRepository(lesson: viewerLesson(sections: 1));
    final controller = viewerController(lessons);
    await controller.load();
    expect(controller.canGoPrevious, isFalse);
    expect(controller.canGoNext, isFalse);
    await controller.goToNext();
    expect(controller.sectionIndex.value, 0);
    expect(lessons.saved, isEmpty);
  });

  test('an empty lesson has no current section and ignores navigation', () async {
    final lessons = FakeViewerLessonRepository(lesson: viewerLesson(sections: 0), lastSection: 3);
    final controller = viewerController(lessons);
    await controller.load();
    expect(controller.currentSection, isNull);
    expect(controller.sectionIndex.value, 0);
    await controller.goToNext();
    await controller.goToPrevious();
    expect(lessons.saved, isEmpty);
  });

  test('a failed load exposes the failure and retry clears it', () async {
    final lessons = FakeViewerLessonRepository(fails: true);
    final controller = viewerController(lessons);
    await controller.load();
    expect(controller.failure.value, isNotNull);
    expect(controller.lesson.value, isNull);
    lessons.fails = false;
    await controller.load();
    expect(controller.failure.value, isNull);
    expect(controller.currentSection, isNotNull);
  });

  test('the tutor is enabled only when both the lesson and its subject enable it', () async {
    for (final (lesson, subject) in [(true, true), (true, false), (false, true), (false, false)]) {
      final controller = viewerController(
        FakeViewerLessonRepository(lesson: viewerLesson(tutorEnabled: lesson)),
        subjectTutorEnabled: subject,
      );
      await controller.load();
      expect(controller.tutorEnabled.value, lesson && subject, reason: '$lesson/$subject');
    }
  });

  test('the font scale starts from the saved value and cycles through the steps', () async {
    final prefs = FakeReadingPreferences(1.15);
    final controller = viewerController(FakeViewerLessonRepository(), preferences: prefs)..onInit();
    expect(controller.fontScale.value, 1.15);
    await controller.cycleFontScale();
    expect(controller.fontScale.value, 1.3);
    expect(prefs.fontScale, 1.3);
    await controller.cycleFontScale();
    expect(prefs.fontScale, 1.0);
  });

  test('a retry after another page opened reloads the same lesson', () async {
    addTearDown(() => Get.parameters = {});
    Get.parameters = {'lessonId': viewerLessonId, 'tab': 'pdf'};
    final lessons = FakeViewerLessonRepository();
    final controller = viewerController(lessons);
    await controller.load();
    Get.parameters = {};
    await controller.load();
    expect(lessons.requested, [viewerLessonId, viewerLessonId]);
  });
}
