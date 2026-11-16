import '../repositories/answer_notification_repository.dart';

class ObserveAnswerTapsUseCase {
  ObserveAnswerTapsUseCase(this._repository);
  final AnswerNotificationRepository _repository;

  Stream<int> call() => _repository.taps;
}
