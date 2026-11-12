import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../../../core/services/tutor_engine_state.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/question_history_item.dart';
import '../../domain/entities/quick_action.dart';
import '../../domain/entities/saved_answer.dart';
import '../../domain/entities/tutor_event.dart';
import '../../domain/usecases/add_question_history_usecase.dart';
import '../../domain/usecases/ask_tutor_params.dart';
import '../../domain/usecases/ask_tutor_usecase.dart';
import '../../domain/usecases/flush_pending_reports_usecase.dart';
import '../../domain/usecases/quick_action_usecase.dart';
import '../../domain/usecases/save_answer_usecase.dart';
import '../../domain/usecases/stop_generation_usecase.dart';
import '../widgets/lesson_picker_sheet.dart';
import 'chat_transcript.dart';

/// The chat tab. Streaming and token batching live in [ChatTranscript].
class TutorController extends GetxController {
  TutorController({
    required AskTutorUseCase ask,
    required QuickActionUseCase quick,
    required StopGenerationUseCase stop,
    required AddQuestionHistoryUseCase addHistory,
    required SaveAnswerUseCase saveAnswer,
    required FlushPendingReportsUseCase flushReports,
    required TutorEngineService engine,
    required ConnectivityService connectivity,
  })  : _ask = ask,
        _quick = quick,
        _stop = stop,
        _addHistory = addHistory,
        _saveAnswer = saveAnswer,
        _flushReports = flushReports,
        _engine = engine,
        _connectivity = connectivity;

  final AskTutorUseCase _ask;
  final QuickActionUseCase _quick;
  final StopGenerationUseCase _stop;
  final AddQuestionHistoryUseCase _addHistory;
  final SaveAnswerUseCase _saveAnswer;
  final FlushPendingReportsUseCase _flushReports;
  final TutorEngineService _engine;
  final ConnectivityService _connectivity;

  final input = TextEditingController();
  final _transcript = ChatTranscript();
  final isGenerating = false.obs;
  final savedIds = <int>{}.obs;

  final subjectId = RxnString();
  final lessonId = RxnString();
  final lessonTitle = RxnString();

  /// False for subjects/lessons the tutor can't handle yet (math).
  final tutorSupported = true.obs;

  StreamSubscription<TutorEvent>? _subscription;

  RxList<ChatMessage> get messages => _transcript.messages;

  Rx<TutorEngineState> get engineState => _engine.state;

  /// The student can type when the model is usable or loading (the question
  /// is queued), or on a search-only device.
  bool get canAsk => switch (_engine.state.value) {
        Downloaded() || Loading() || Ready() || SearchOnly() => true,
        _ => false,
      };

  bool get isLoadingModel => _engine.state.value is Loading;
  bool get isSearchOnly => _engine.state.value is SearchOnly;
  bool get hasLesson => lessonId.value != null;

  @override
  void onReady() {
    super.onReady();
    _flushReports();
    // Queued reports go out as soon as the device comes online.
    ever(_connectivity.network, (_) {
      if (_connectivity.isOnline) _flushReports();
    });
  }

  void selectLesson({
    required String subject,
    String? lesson,
    String? title,
    required bool tutorEnabled,
  }) {
    subjectId.value = subject;
    lessonId.value = lesson;
    lessonTitle.value = title;
    tutorSupported.value = tutorEnabled;
  }

  void newChat() {
    stop();
    _transcript.clear();
  }

  Future<void> send() async {
    final question = input.text.trim();
    final subject = subjectId.value;
    if (question.isEmpty || isGenerating.value || !tutorSupported.value) return;
    if (subject == null) {
      showLessonPickerSheet(); // the question stays in the field
      return;
    }
    input.clear();
    await _addHistory(QuestionHistoryItem(
        subjectId: subject, lessonId: lessonId.value, question: question));
    _begin(
      question,
      _ask(AskTutorParams(question: question, subjectId: subject, lessonId: lessonId.value)),
    );
  }

  void quickAction(QuickAction action, String label) {
    final subject = subjectId.value;
    final lesson = lessonId.value;
    if (subject == null || lesson == null || isGenerating.value) return;
    _begin(
      label,
      _quick(QuickActionParams(action: action, subjectId: subject, lessonId: lesson)),
    );
  }

  Future<void> stop() async {
    if (!isGenerating.value) return;
    await _subscription?.cancel();
    await _stop();
    _finish();
  }

  Future<void> save(ChatMessage message) async {
    final subject = subjectId.value;
    if (subject == null || message.question == null) return;
    await _saveAnswer(SavedAnswer(
      subjectId: subject,
      lessonId: lessonId.value,
      question: message.question!,
      answer: message.text,
      sourcePage: message.source?.page,
    ));
    savedIds.add(message.id);
  }

  void _begin(String question, Stream<TutorEvent> events) {
    final answerId = _transcript.startExchange(question, question: question);
    isGenerating.value = true;
    _subscription = events.listen(
      (e) {
        if (e is TutorSubjectUnsupported) tutorSupported.value = false;
        _transcript.apply(answerId, e);
      },
      onError: (Object _) => _transcript.fail(answerId),
      onDone: _finish,
    );
  }

  void _finish() {
    _transcript.finish();
    _subscription = null;
    isGenerating.value = false;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _transcript.dispose();
    input.dispose();
    super.onClose();
  }
}
