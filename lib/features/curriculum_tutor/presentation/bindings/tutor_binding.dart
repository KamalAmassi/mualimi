import 'package:get/get.dart';

import '../../../../core/services/tutor_engine_service.dart';
import '../../../subjects/domain/usecases/get_subject_detail_usecase.dart';
import '../../../subjects/domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/ask_tutor_usecase.dart';
import '../../domain/usecases/delete_pending_question_usecase.dart';
import '../../domain/usecases/delete_saved_answer_usecase.dart';
import '../../domain/usecases/flush_pending_reports_usecase.dart';
import '../../domain/usecases/follow_up_usecase.dart';
import '../../domain/usecases/get_example_questions_usecase.dart';
import '../../domain/usecases/get_history_item_usecase.dart';
import '../../domain/usecases/get_pending_questions_usecase.dart';
import '../../domain/usecases/get_question_history_usecase.dart';
import '../../domain/usecases/get_quick_answer_usecase.dart';
import '../../domain/usecases/get_saved_answers_usecase.dart';
import '../../domain/usecases/observe_answer_taps_usecase.dart';
import '../../domain/usecases/observe_tutor_connection_usecase.dart';
import '../../domain/usecases/process_pending_questions_usecase.dart';
import '../../domain/usecases/request_answer_notifications_usecase.dart';
import '../../domain/usecases/save_answer_usecase.dart';
import '../../domain/usecases/stop_generation_usecase.dart';
import '../../domain/usecases/submit_report_usecase.dart';
import '../controllers/lesson_picker_controller.dart';
import '../controllers/pending_conversation.dart';
import '../controllers/report_controller.dart';
import '../controllers/saved_controller.dart';
import '../controllers/tutor_controller.dart';
import '../controllers/tutor_selection.dart';
import '../controllers/tutor_use_cases.dart';
import 'tutor_data_binding.dart';
import 'tutor_use_case_binding.dart';
import '../services/pending_question_sync_service.dart';

/// Wires the whole tutor feature. Used by the shell (chat tab) and /saved.
class TutorBinding extends Bindings {
  @override
  void dependencies() {
    TutorDataBinding().dependencies();
    TutorUseCaseBinding().dependencies();
    Get.lazyPut(
      () => PendingQuestionSyncService(
        process: Get.find<ProcessPendingQuestionsUseCase>(),
        connection: Get.find<ObserveTutorConnectionUseCase>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => TutorSelection(
        Get.find<GetSubjectsUseCase>(),
        Get.find<GetSubjectDetailUseCase>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => TutorController(
        selection: Get.find<TutorSelection>(),
        useCases: TutorUseCases(
          ask: Get.find<AskTutorUseCase>(),
          quick: Get.find<GetQuickAnswerUseCase>(),
          followUp: Get.find<FollowUpUseCase>(),
          stop: Get.find<StopGenerationUseCase>(),
          saveAnswer: Get.find<SaveAnswerUseCase>(),
          deletePending: Get.find<DeletePendingQuestionUseCase>(),
          getExamples: Get.find<GetExampleQuestionsUseCase>(),
          requestNotifications: Get.find<RequestAnswerNotificationsUseCase>(),
          flushReports: Get.find<FlushPendingReportsUseCase>(),
        ),
        engine: Get.find<TutorEngineService>(),
        pendingConversation: (transcript, onOpenAnswer) => PendingConversation(
          transcript: transcript,
          sync: Get.find<PendingQuestionSyncService>(),
          getPending: Get.find<GetPendingQuestionsUseCase>(),
          getHistoryItem: Get.find<GetHistoryItemUseCase>(),
          observeTaps: Get.find<ObserveAnswerTapsUseCase>(),
          onOpenAnswer: onOpenAnswer,
        ),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => LessonPickerController(
        Get.find<GetSubjectsUseCase>(),
        Get.find<GetSubjectDetailUseCase>(),
        Get.find<TutorSelection>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => ReportController(Get.find<SubmitReportUseCase>()),
        fenix: true);
    Get.lazyPut(
      () => SavedController(
        Get.find<GetSavedAnswersUseCase>(),
        Get.find<GetQuestionHistoryUseCase>(),
        Get.find<DeleteSavedAnswerUseCase>(),
        Get.find<TutorController>(),
      ),
      fenix: true,
    );
  }
}
