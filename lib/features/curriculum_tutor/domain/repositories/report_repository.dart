import '../entities/pending_report.dart';

abstract class ReportRepository {
  Future<void> queue(PendingReport report);

  /// Sends queued reports; returns how many were delivered and removed.
  Future<int> sendPending();
}
