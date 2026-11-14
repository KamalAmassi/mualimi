import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../../shell/presentation/controllers/shell_controller.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/follow_up.dart';
import '../../domain/entities/question_history_item.dart';
import '../../domain/entities/quick_action.dart';
import '../../domain/entities/saved_answer.dart';
import '../../domain/entities/tutor_event.dart';
import '../../domain/usecases/ask_tutor_params.dart';
import '../../domain/usecases/follow_up_usecase.dart';
import '../../domain/usecases/get_quick_answer_usecase.dart';
import '../formatting/example_questions.dart';
import '../widgets/lesson_picker_sheet.dart';
import 'chat_scroller.dart';
import 'chat_transcript.dart';
import 'pending_conversation.dart';
import 'tutor_selection.dart';
import 'tutor_use_cases.dart';

/// The chat tab. Streaming and token batching live in [ChatTranscript].
class TutorController extends GetxController {
  TutorController({
    required this.selection,
    required TutorUseCases useCases,
    required TutorEngineService engine,
    required PendingConversation Function(ChatTranscript, void Function())
        pendingConversation,
  })  : _use = useCases,
        _engine = engine {
    _pending = pendingConversation(_transcript, _openTutorTab);
  }

  final TutorSelection selection;
  final TutorUseCases _use;
  final TutorEngineService _engine;
  final _transcript = ChatTranscript();
  final _scroller = ChatScroller();
  late final PendingConversation _pending;

  final input = TextEditingController();
  final isGenerating = false.obs;
  final savedIds = <int>{}.obs;
  final examples = <String>[].obs;

  StreamSubscription<TutorEvent>? _subscription;
  Worker? _engineWatcher;

  RxList<ChatMessage> get messages => _transcript.messages;
  Rx<TutorEngineState> get engineState => _engine.state;
  ScrollController get scroll => _scroller.controller;

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    await selection.load();
    await _refreshExamples();
    ever(selection.subjectId, (_) => _refreshExamples());
    ever(selection.lessonId, (_) => _refreshExamples());
    ever(messages, (_) => _scroller.jumpToEnd());
    _engineWatcher = ever(_engine.state, (s) {
      if (s == TutorEngineState.ready) _use.flushReports();
    });
    _use.flushReports();
    await _pending.start();
  }

  /// Contract with the lesson page: "Ask the tutor" pre-selects subject and lesson.
  void selectLesson({
    required String subject,
    String? lesson,
    String? title,
    required bool tutorEnabled,
  }) =>
      selection.select(
          subject: subject,
          lesson: lesson,
          title: title,
          tutorEnabled: tutorEnabled);

  void send() {
    final question = input.text.trim();
    if (question.isEmpty) return;
    input.clear();
    ask(question);
  }

  void ask(String question) {
    final subject = selection.subjectId.value;
    if (isGenerating.value || !selection.supported.value) return;
    if (subject == null) {
      showLessonPickerSheet();
      return;
    }
    _begin(
      question,
      question,
      _use.ask(AskTutorParams(
          question: question,
          subjectId: subject,
          lessonId: selection.lessonId.value)),
    );
  }

  void quickAction(QuickAction action) {
    final subject = selection.subjectId.value;
    final lesson = selection.lessonId.value;
    if (subject == null || lesson == null || isGenerating.value) return;
    _begin(
      action.label,
      action.label,
      _use.quick(QuickAnswerParams(
          lessonId: lesson, subjectId: subject, action: action)),
    );
  }

  void followUp(ChatMessage answer, FollowUp followUp) {
    final subject = selection.subjectId.value;
    final question = answer.question;
    if (subject == null || question == null || isGenerating.value) return;
    _begin(
      followUp.label,
      question,
      _use.followUp(FollowUpParams(
        followUp: followUp,
        question: question,
        previousAnswer: answer.text,
        subjectId: subject,
        lessonId: selection.lessonId.value,
        passages: answer.passages,
      )),
    );
  }

  Future<void> stop() async {
    if (isGenerating.value) await _use.stop();
  }

  Future<void> save(ChatMessage message) async {
    final question = message.question;
    if (question == null) return;
    await _use.saveAnswer(SavedAnswer(
      question: question,
      answer: message.text,
      source: message.source,
      fromBank: message.fromBank,
    ));
    savedIds.add(message.id);
  }

  Future<void> deletePending(ChatMessage message) async {
    final id = message.pendingQuestionId;
    if (id == null) return;
    await _use.deletePending(id);
    _transcript.removePending(id);
  }

  /// Shows a stored answer from the question history and returns to the chat.
  void showHistoryItem(QuestionHistoryItem item) {
    _transcript.addHistoryItem(item);
    _openTutorTab();
  }

  void openSubject() {
    final subject = selection.subjectId.value;
    if (subject != null) Get.toNamed<void>(AppRoutes.subjectOf(subject));
  }

  /// Contract with the pack viewer: lesson id and the PDF page to open.
  void openInPack(String lessonId, int pdfPage) => Get.toNamed<void>(
      '${AppRoutes.viewerOf(lessonId, tab: 'pdf')}&pdfPage=$pdfPage');

  void _begin(String userText, String question, Stream<TutorEvent> events) {
    final answerId = _transcript.startExchange(userText, question: question);
    isGenerating.value = true;
    _subscription = events.listen(
      (e) {
        if (e is TutorOffline && e.pendingQuestionId != null) {
          _use.requestNotifications();
        }
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

  Future<void> _refreshExamples() async {
    final subject = selection.subjectId.value;
    if (subject == null) return;
    final stored =
        await _use.getExamples(subject, lessonId: selection.lessonId.value);
    examples.assignAll(ExampleQuestions.fill(
      stored,
      subjectName: selection.subjectName,
      lessonTitle: selection.lessonTitle.value,
    ));
  }

  void _openTutorTab() => Get.find<ShellController>().openTutor();

  @override
  void onClose() {
    _subscription?.cancel();
    _engineWatcher?.dispose();
    _pending.dispose();
    _transcript.dispose();
    _scroller.dispose();
    input.dispose();
    super.onClose();
  }
}
