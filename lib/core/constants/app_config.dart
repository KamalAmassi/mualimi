/// Remote endpoints and download tuning that deployment may change.
abstract final class AppConfig {
  // TODO: replace with the real manifest URL once hosting is decided.
  static const manifestUrl = 'https://example.invalid/mualimi/manifest.json';
  static const httpTimeoutSeconds = 20;

  /// MVP: only grade 9 is offered.
  static const availableGrades = [9];
}
