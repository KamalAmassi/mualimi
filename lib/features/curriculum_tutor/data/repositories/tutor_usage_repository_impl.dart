import '../../../../core/constants/limits.dart';
import '../../domain/repositories/tutor_usage_repository.dart';
import '../datasources/tutor_usage_local_data_source.dart';

class TutorUsageRepositoryImpl implements TutorUsageRepository {
  TutorUsageRepositoryImpl(this._local);
  final TutorUsageLocalDataSource _local;

  @override
  Future<bool> isDailyLimitReached() async =>
      await _local.countToday() >= Limits.dailyQuestionLimit;

  @override
  Future<void> recordQuestion() => _local.increment();
}
