import 'dart:convert';

import '../../../../core/error/exceptions.dart';

/// Reads one response payload into answer text.
abstract final class LlmResponseReader {
  /// The text of the first candidate; empty when the payload carries none
  /// (for example a final chunk with only usage data). Throws [LlmException]
  /// for an error payload or a blocked prompt.
  static String text(String payload) {
    final Object? json;
    try {
      json = jsonDecode(payload);
    } on FormatException {
      throw const LlmException('malformed response');
    }
    if (json is! Map<String, dynamic>) {
      throw const LlmException('malformed response');
    }

    final error = json['error'];
    if (error is Map<String, dynamic>) {
      throw LlmException('${error['status'] ?? error['code'] ?? 'error'}');
    }
    final candidates = json['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      final feedback = json['promptFeedback'];
      if (feedback is Map<String, dynamic> && feedback['blockReason'] != null) {
        throw LlmException('blocked: ${feedback['blockReason']}');
      }
      return '';
    }
    final content = (candidates.first as Map<String, dynamic>)['content'];
    final parts = content is Map<String, dynamic> ? content['parts'] : null;
    if (parts is! List) return '';
    return parts.map((p) => (p as Map<String, dynamic>)['text'] ?? '').join();
  }
}
