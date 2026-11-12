import '../../domain/entities/pending_report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_local_data_source.dart';
import '../datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._local, this._remote);

  final ReportLocalDataSource _local;
  final ReportRemoteDataSource _remote;

  @override
  Future<void> queue(PendingReport report) => _local.add(report);

  @override
  Future<int> sendPending() async {
    var sent = 0;
    for (final report in await _local.all()) {
      if (!await _remote.send(report)) continue; // keep it queued for next time
      await _local.remove(report.id!);
      sent++;
    }
    return sent;
  }
}
