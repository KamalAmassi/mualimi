import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/observe_tutor_connection_usecase.dart';
import '../../domain/usecases/process_pending_questions_usecase.dart';

/// Answers queued questions whenever the connection returns, while the app
/// is running. One run at a time; each answer is published on [answers].
class PendingQuestionSyncService extends GetxService {
  PendingQuestionSyncService({
    required ProcessPendingQuestionsUseCase process,
    required ObserveTutorConnectionUseCase connection,
  })  : _process = process,
        _connection = connection;

  final ProcessPendingQuestionsUseCase _process;
  final ObserveTutorConnectionUseCase _connection;
  final _answers = StreamController<SyncedAnswer>.broadcast();
  StreamSubscription<bool>? _online;
  bool _running = false;

  Stream<SyncedAnswer> get answers => _answers.stream;

  @override
  void onInit() {
    super.onInit();
    _online = _connection().listen((_) => syncNow());
    syncNow();
  }

  Future<void> syncNow() async {
    if (_running) return;
    _running = true;
    try {
      await for (final answer in _process(const NoParams())) {
        _answers.add(answer);
      }
    } finally {
      _running = false;
    }
  }

  @override
  void onClose() {
    _online?.cancel();
    _answers.close();
    super.onClose();
  }
}
