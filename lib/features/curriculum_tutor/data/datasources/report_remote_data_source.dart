import '../../domain/entities/pending_report.dart';

abstract class ReportRemoteDataSource {
  /// True once the server accepted the report.
  Future<bool> send(PendingReport report);
}

/// TODO(reports-endpoint): no reporting endpoint exists yet. Until one does,
/// reports stay queued in user.db and nothing is sent.
class UnconfiguredReportRemoteDataSource implements ReportRemoteDataSource {
  @override
  Future<bool> send(PendingReport report) async => false;
}
