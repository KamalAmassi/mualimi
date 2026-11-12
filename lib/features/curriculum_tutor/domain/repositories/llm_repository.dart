abstract class LlmRepository {
  /// Streams tokens. Waits for the model to be ready (queued while loading).
  /// Throws `ModelException` if it can't become ready.
  Stream<String> generate(String prompt, {required int maxOutputTokens});

  Future<void> stop();
}
