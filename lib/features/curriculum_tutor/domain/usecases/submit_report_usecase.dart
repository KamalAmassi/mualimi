import '../entities/pending_report.dart';
import '../repositories/report_repository.dart';

class SubmitReportUseCase {
  SubmitReportUseCase(this._repository);
  final ReportRepository _repository;

  /// Reports are queued locally and sent when the device is online.
  Future<void> call(PendingReport report) => _repository.queue(report);
}
