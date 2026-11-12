abstract class LlmDataSource {
  /// Streams generated tokens for [prompt]. Waits until the model is ready.
  Stream<String> generate(String prompt, {required int maxOutputTokens});

  Future<void> stop();
}
