import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/answer_notification_repository.dart';
import '../datasources/local_notification_data_source.dart';

class AnswerNotificationRepositoryImpl implements AnswerNotificationRepository {
  AnswerNotificationRepositoryImpl(this._source);
  final LocalNotificationDataSource _source;

  static const _previewLength = 40;

  @override
  Future<void> notifyAnswerReady(
      {required String question, required int historyId}) {
    final preview = question.length > _previewLength
        ? question.substring(0, _previewLength)
        : question;
    return _source.show(
      id: historyId,
      title: AppStrings.appName,
      body: '${AppStrings.answerReadyPrefix} $preview…',
      payload: '$historyId',
    );
  }

  @override
  Future<void> requestPermission() => _source.requestPermission();

  @override
  Stream<int> get taps =>
      _source.taps.map(int.tryParse).where((id) => id != null).cast<int>();
}
