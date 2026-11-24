import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/features/lesson/domain/entities/callout_kind.dart';

void main() {
  test('the remember marker is the pack-format text with shadda and colon', () {
    expect(CalloutKind.remember.marker.runes.toList(),
        [0x062A, 0x0630, 0x0643, 0x0651, 0x0631, 0x003A]);
  });

  test('the warning marker is the pack-format text with colon', () {
    expect(CalloutKind.warning.marker.runes.toList(),
        [0x0627, 0x0646, 0x062A, 0x0628, 0x0647, 0x003A]);
  });
}
