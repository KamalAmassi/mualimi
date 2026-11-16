import '../../domain/entities/llm_prompt.dart';

abstract class LlmDataSource {
  /// Streams answer text as it is generated. Throws [NetworkException] or
  /// [LlmException]. After [stop] the stream ends normally.
  Stream<String> streamAnswer(LlmPrompt prompt);

  /// The complete answer in a single request.
  Future<String> generate(LlmPrompt prompt);

  bool get wasStopped;

  /// Aborts the request in flight and closes its connection.
  Future<void> stop();
}
