import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/limits.dart';
import '../../../../core/constants/tutor_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/llm_prompt.dart';
import 'llm_response_reader.dart';
import 'llm_data_source.dart';
import 'sse_data_parser.dart';

/// Talks to the Gemini REST API. The key never leaves the request header.
class GeminiClient implements LlmDataSource {
  GeminiClient({http.Client? client, String? apiKey})
      : _client = client ?? http.Client(),
        _apiKey = apiKey ?? TutorConfig.apiKey;

  final http.Client _client;
  final String _apiKey;
  Completer<void>? _abort;
  bool _stopped = false;

  @override
  bool get wasStopped => _stopped;

  @override
  Stream<String> streamAnswer(LlmPrompt prompt) async* {
    _stopped = false;
    final abort = _abort = Completer<void>();
    try {
      final response =
          await _send(prompt, 'streamGenerateContent?alt=sse', abort);
      final parser = SseDataParser();
      await for (final text in response.stream.transform(utf8.decoder)) {
        for (final payload in parser.add(text)) {
          final piece = LlmResponseReader.text(payload);
          if (piece.isNotEmpty) yield piece;
        }
      }
      for (final payload in parser.close()) {
        final piece = LlmResponseReader.text(payload);
        if (piece.isNotEmpty) yield piece;
      }
    } on http.RequestAbortedException {
      if (!_stopped) throw const NetworkException('request aborted');
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on http.ClientException catch (e) {
      if (!_stopped) throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('timeout');
    } finally {
      // Cancelling the listener lands here too; completing closes the connection.
      if (!abort.isCompleted) abort.complete();
    }
  }

  @override
  Future<String> generate(LlmPrompt prompt) async {
    final abort = _abort = Completer<void>();
    _stopped = false;
    try {
      final response = await _send(prompt, 'generateContent', abort);
      return LlmResponseReader.text(await response.stream.bytesToString());
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('timeout');
    } finally {
      if (!abort.isCompleted) abort.complete();
    }
  }

  @override
  Future<void> stop() async {
    _stopped = true;
    final abort = _abort;
    if (abort != null && !abort.isCompleted) abort.complete();
  }

  Future<http.StreamedResponse> _send(
    LlmPrompt prompt,
    String method,
    Completer<void> abort,
  ) async {
    if (_apiKey.isEmpty) throw const LlmException('not configured');
    final request = http.AbortableRequest(
      'POST',
      Uri.parse('${TutorConfig.baseUrl}/models/${TutorConfig.model}:$method'),
      abortTrigger: abort.future,
    )
      ..headers['content-type'] = 'application/json'
      ..headers['x-goog-api-key'] = _apiKey
      ..body = jsonEncode(_body(prompt));
    final response = await _client
        .send(request)
        .timeout(const Duration(seconds: TutorConfig.requestTimeoutSeconds));
    if (response.statusCode == 200) return response;

    final body = await response.stream.bytesToString();
    if (response.statusCode >= 500 || response.statusCode == 429) {
      throw NetworkException('http ${response.statusCode}');
    }
    throw LlmException('http ${response.statusCode}: ${_errorStatus(body)}');
  }

  Map<String, Object?> _body(LlmPrompt prompt) => {
        'systemInstruction': {
          'parts': [
            {'text': prompt.systemInstruction},
          ],
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt.userMessage},
            ],
          },
        ],
        'generationConfig': {
          'temperature': Limits.generationTemperature,
          'maxOutputTokens': Limits.maxOutputTokens,
        },
      };

  String _errorStatus(String body) {
    try {
      final error = (jsonDecode(body) as Map<String, dynamic>)['error'];
      return error is Map<String, dynamic> ? '${error['status']}' : 'error';
    } on Object {
      return 'error';
    }
  }
}
