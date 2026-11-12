import '../repositories/report_repository.dart';

class FlushPendingReportsUseCase {
  FlushPendingReportsUseCase(this._repository);
  final ReportRepository _repository;

  Future<int> call() => _repository.sendPending();
}
