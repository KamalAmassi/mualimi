import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mualimi/core/error/failures.dart';

import 'key_terms_fakes.dart';

void main() {
  test('load keeps the repository order and the lesson title', () async {
    final controller = keyTermsController(FakeKeyTermsRepository());
    await controller.load();
    expect(controller.terms, keyTermsSample);
    expect(controller.lessonTitle.value, keyTermsLessonTitle);
    expect(controller.loading.value, isFalse);
    expect(controller.index.value, 0);
  });

  test('next and previous stay within bounds', () async {
    final controller = keyTermsController(FakeKeyTermsRepository());
    await controller.load();
    expect(controller.hasPrevious, isFalse);
    controller.previous();
    expect(controller.index.value, 0);
    controller
      ..next()
      ..next();
    expect(controller.index.value, 2);
    expect(controller.hasNext, isFalse);
    controller.next();
    expect(controller.index.value, 2);
    controller.previous();
    expect(controller.index.value, 1);
  });

  test('flip toggles the side and moving to another card shows the term', () async {
    final controller = keyTermsController(FakeKeyTermsRepository());
    await controller.load();
    controller.flip();
    expect(controller.showingDefinition.value, isTrue);
    controller.flip();
    expect(controller.showingDefinition.value, isFalse);
    controller
      ..flip()
      ..next();
    expect(controller.showingDefinition.value, isFalse);
  });

  test('showCard jumps to the card, shows its term and ignores bad positions', () async {
    final controller = keyTermsController(FakeKeyTermsRepository());
    await controller.load();
    controller
      ..flip()
      ..showCard(2);
    expect(controller.index.value, 2);
    expect(controller.current, keyTermsSample[2]);
    expect(controller.showingDefinition.value, isFalse);
    controller
      ..showCard(5)
      ..showCard(-1);
    expect(controller.index.value, 2);
  });

  test('a lesson without key terms ends with an empty list', () async {
    final controller = keyTermsController(FakeKeyTermsRepository(terms: const []));
    await controller.load();
    expect(controller.terms, isEmpty);
    expect(controller.hasNext, isFalse);
    expect(controller.hasPrevious, isFalse);
  });

  test('failures leave no terms and no title', () async {
    final controller = keyTermsController(FakeKeyTermsRepository(
      termsFailure: const DatabaseFailure(),
      lessonFailure: const DatabaseFailure(),
    ));
    await controller.load();
    expect(controller.terms, isEmpty);
    expect(controller.failure.value, const DatabaseFailure());
    expect(controller.lessonTitle.value, isNull);
    expect(controller.loading.value, isFalse);
  });

  test('a reload after another page opened keeps the same lesson', () async {
    addTearDown(() => Get.parameters = {});
    Get.parameters = {'lessonId': 'lesson-1'};
    final repository = FakeKeyTermsRepository();
    final controller = keyTermsController(repository);
    await controller.load();
    Get.parameters = {};
    await controller.load();
    expect(repository.requested, ['lesson-1', 'lesson-1']);
  });
}
