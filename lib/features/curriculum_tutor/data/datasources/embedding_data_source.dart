abstract class EmbeddingDataSource {
  /// Embeds a search query, or null when no embedding model is available
  /// (search then uses keywords only).
  Future<List<double>?> embedQuery(String text);
}
