import '../repositories/answer_notification_repository.dart';

class RequestAnswerNotificationsUseCase {
  RequestAnswerNotificationsUseCase(this._repository);
  final AnswerNotificationRepository _repository;

  Future<void> call() => _repository.requestPermission();
}
