/// Loads and unloads the on-device LLM. Implemented by the tutor feature
/// (flutter_gemma) so core never depends on a feature.
abstract class ModelRuntime {
  Future<void> load(String modelPath);
  Future<void> unload();
}
