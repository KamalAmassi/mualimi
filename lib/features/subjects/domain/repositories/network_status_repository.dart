abstract class NetworkStatusRepository {
  /// Emits the current state first, then every change.
  Stream<bool> watchOnline();
}
