import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/domain/entities/section_block.dart';

import 'section_body_fakes.dart';

void main() {
  test('the same body is parsed once and a new body is parsed again', () {
    final controller = sectionBodyController();
    final first = controller.blocksOf('## A');
    expect(first, [isA<HeadingBlock>()]);
    expect(identical(controller.blocksOf('## A'), first), isTrue);
    expect(controller.blocksOf('text'), [isA<ParagraphBlock>()]);
  });

  test('image paths come from the pack image repository', () {
    final images = FakePackImageRepository('/pack/images/a.webp');
    final controller = sectionBodyController(images);
    expect(controller.imagePathOf('images/a.webp'), '/pack/images/a.webp');
    expect(images.requested, ['images/a.webp']);
  });
}
