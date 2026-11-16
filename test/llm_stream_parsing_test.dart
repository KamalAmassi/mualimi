import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/llm_response_reader.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/sse_data_parser.dart';

const _first =
    '{"candidates":[{"content":{"parts":[{"text":"الفرق الأساسي "}],"role":"model"},"index":0}],"usageMetadata":{"promptTokenCount":120},"modelVersion":"test"}';
const _second =
    '{"candidates":[{"content":{"parts":[{"text":"هو الملامسة."}],"role":"model"},"finishReason":"STOP","index":0}],"usageMetadata":{"promptTokenCount":120,"candidatesTokenCount":9}}';

void main() {
  group('SseDataParser', () {
    test('reads events separated by blank lines', () {
      final parser = SseDataParser();
      expect(parser.add('data: $_first\r\n\r\ndata: $_second\r\n\r\n'),
          [_first, _second]);
    });

    test('keeps a partial line until the rest arrives', () {
      final parser = SseDataParser();
      expect(parser.add('data: {"a"'), isEmpty);
      expect(parser.add(':1}\n'), isEmpty);
      expect(parser.add('\n'), ['{"a":1}']);
    });

    test('a chunk boundary inside the line break is handled', () {
      final parser = SseDataParser();
      expect(parser.add('data: x\r'), isEmpty);
      expect(parser.add('\n\r\n'), ['x']);
    });

    test('ignores extra blank lines, comments and other fields', () {
      final parser = SseDataParser();
      expect(
          parser.add('\n\n: keep-alive\nevent: message\nid: 7\ndata: x\n\n\n'),
          ['x']);
    });

    test('joins multi-line data with a newline', () {
      final parser = SseDataParser();
      expect(parser.add('data: a\ndata: b\n\n'), ['a\nb']);
    });

    test('close flushes an event without a closing blank line', () {
      final parser = SseDataParser();
      expect(parser.add('data: last'), isEmpty);
      expect(parser.close(), ['last']);
      expect(parser.close(), isEmpty);
    });
  });

  group('LlmResponseReader', () {
    test('reads the text of the first candidate', () {
      expect(LlmResponseReader.text(_first), 'الفرق الأساسي ');
      expect(LlmResponseReader.text(_second), 'هو الملامسة.');
    });

    test('joins several text parts', () {
      const payload =
          '{"candidates":[{"content":{"parts":[{"text":"أ"},{"text":"ب"}]}}]}';
      expect(LlmResponseReader.text(payload), 'أب');
    });

    test('a chunk without text gives an empty string', () {
      expect(LlmResponseReader.text('{"usageMetadata":{"totalTokenCount":5}}'),
          '');
      expect(LlmResponseReader.text('{"candidates":[{"finishReason":"STOP"}]}'),
          '');
    });

    test('an error payload throws', () {
      const payload =
          '{"error":{"code":503,"message":"The model is overloaded.","status":"UNAVAILABLE"}}';
      expect(
        () => LlmResponseReader.text(payload),
        throwsA(isA<LlmException>()
            .having((e) => e.message, 'message', 'UNAVAILABLE')),
      );
    });

    test('a blocked prompt throws', () {
      const payload = '{"promptFeedback":{"blockReason":"SAFETY"}}';
      expect(
          () => LlmResponseReader.text(payload),
          throwsA(isA<LlmException>()
              .having((e) => e.message, 'message', contains('SAFETY'))));
    });

    test('malformed JSON throws', () {
      expect(() => LlmResponseReader.text('{not json'),
          throwsA(isA<LlmException>()));
    });
  });

  test('a recorded stream decodes to the full answer', () {
    final parser = SseDataParser();
    const wire = 'data: $_first\r\n\r\ndata: $_second\r\n\r\n';
    final events = <String>[];
    // Feed in uneven pieces, as a socket would.
    for (var i = 0; i < wire.length; i += 37) {
      events.addAll(parser
          .add(wire.substring(i, i + 37 > wire.length ? wire.length : i + 37)));
    }
    expect(events.map(LlmResponseReader.text).join(),
        'الفرق الأساسي هو الملامسة.');
  });
}
