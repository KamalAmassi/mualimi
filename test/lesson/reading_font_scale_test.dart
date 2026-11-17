import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/domain/entities/reading_font_scale.dart';

void main() {
  test('steps up and wraps to the smallest size', () {
    expect(ReadingFontScale.next(1.0), 1.15);
    expect(ReadingFontScale.next(1.15), 1.3);
    expect(ReadingFontScale.next(1.3), 1.0);
  });

  test('a value between steps moves to the next step above it', () {
    expect(ReadingFontScale.next(1.2), 1.3);
    expect(ReadingFontScale.next(0.8), 1.0);
    expect(ReadingFontScale.next(2.0), 1.0);
  });
}
