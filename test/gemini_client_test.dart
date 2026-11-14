import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mualimi/core/constants/limits.dart';
import 'package:mualimi/core/error/exceptions.dart';
import 'package:mualimi/features/curriculum_tutor/data/datasources/gemini_client.dart';
import 'package:mualimi/features/curriculum_tutor/domain/entities/llm_prompt.dart';

const _prompt =
    LlmPrompt(systemInstruction: 'system text', userMessage: 'user text');

http.StreamedResponse _sse(List<String> events, {int status = 200}) =>
    http.StreamedResponse(
      Stream.value(utf8.encode(events.map((e) => 'data: $e\r\n\r\n').join())),
      status,
    );

String _chunk(String text) => jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': text}
            ]
          }
        }
      ]
    });

void main() {
  test('streams text pieces and sends the documented request', () async {
    late http.BaseRequest seen;
    late Map<String, dynamic> body;
    final client = GeminiClient(
      apiKey: 'test-key',
      client: MockClient.streaming((request, bodyStream) async {
        seen = request;
        body = jsonDecode(await bodyStream.bytesToString())
            as Map<String, dynamic>;
        return _sse([_chunk('مرحباً '), _chunk('بك')]);
      }),
    );

    final pieces = await client.streamAnswer(_prompt).toList();

    expect(pieces, ['مرحباً ', 'بك']);
    expect(seen.url.path, endsWith(':streamGenerateContent'));
    expect(seen.url.queryParameters['alt'], 'sse');
    expect(seen.headers['x-goog-api-key'], 'test-key');
    expect(seen.url.toString(), isNot(contains('test-key')));
    expect(body['systemInstruction']['parts'][0]['text'], 'system text');
    expect(body['contents'][0]['parts'][0]['text'], 'user text');
    expect(body['generationConfig']['temperature'], 0.3);
    expect(body['generationConfig']['maxOutputTokens'], Limits.maxOutputTokens);
  });

  test('without a key nothing is sent', () async {
    var called = false;
    final client = GeminiClient(
      apiKey: '',
      client: MockClient.streaming((_, __) async {
        called = true;
        return _sse([]);
      }),
    );
    await expectLater(
        client.streamAnswer(_prompt).toList(), throwsA(isA<LlmException>()));
    expect(called, isFalse);
  });

  test('a server error is a network failure so the question can be queued',
      () async {
    final client = GeminiClient(
      apiKey: 'k',
      client: MockClient.streaming((_, __) async =>
          http.StreamedResponse(Stream.value(utf8.encode('{}')), 503)),
    );
    await expectLater(client.streamAnswer(_prompt).toList(),
        throwsA(isA<NetworkException>()));
  });

  test('a rejected request is an llm failure', () async {
    final client = GeminiClient(
      apiKey: 'k',
      client: MockClient.streaming((_, __) async => http.StreamedResponse(
          Stream.value(utf8.encode('{"error":{"status":"INVALID_ARGUMENT"}}')),
          400)),
    );
    await expectLater(
        client.streamAnswer(_prompt).toList(), throwsA(isA<LlmException>()));
  });

  test('an error payload inside the stream throws', () async {
    final client = GeminiClient(
      apiKey: 'k',
      client: MockClient.streaming((_, __) async => _sse([
            _chunk('جزء'),
            '{"error":{"code":500,"status":"INTERNAL"}}',
          ])),
    );
    final pieces = <String>[];
    await expectLater(
      client.streamAnswer(_prompt).forEach(pieces.add),
      throwsA(isA<LlmException>()),
    );
    expect(pieces, ['جزء']);
  });

  test('a dropped connection is a network failure', () async {
    final client = GeminiClient(
      apiKey: 'k',
      client: MockClient.streaming(
          (_, __) async => throw http.ClientException('offline')),
    );
    await expectLater(client.streamAnswer(_prompt).toList(),
        throwsA(isA<NetworkException>()));
  });

  test('stop aborts the request and the partial text is kept', () async {
    final started = Completer<void>();
    final client = GeminiClient(
      apiKey: 'k',
      client: MockClient.streaming((request, _) async {
        final controller = StreamController<List<int>>();
        controller.add(utf8.encode('data: ${_chunk('بداية')}\r\n\r\n'));
        started.complete();
        // A real client throws RequestAbortedException on the open response.
        (request as http.Abortable).abortTrigger!.then((_) {
          controller.addError(http.RequestAbortedException());
          controller.close();
        });
        return http.StreamedResponse(controller.stream, 200);
      }),
    );

    final pieces = <String>[];
    final done = client.streamAnswer(_prompt).forEach(pieces.add);
    await started.future;
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await client.stop();
    await done;

    expect(pieces, ['بداية']);
    expect(client.wasStopped, isTrue);
  });

  test('generate returns the whole answer from generateContent', () async {
    late Uri url;
    final client = GeminiClient(
      apiKey: 'k',
      client: MockClient.streaming((request, _) async {
        url = request.url;
        return http.StreamedResponse(
            Stream.value(utf8.encode(_chunk('جواب كامل'))), 200);
      }),
    );
    expect(await client.generate(_prompt), 'جواب كامل');
    expect(url.path, endsWith(':generateContent'));
  });
}
