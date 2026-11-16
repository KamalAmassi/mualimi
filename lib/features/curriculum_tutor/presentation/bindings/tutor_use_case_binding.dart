import 'package:get/get.dart';

import '../../../../core/services/settings_service.dart';
import '../../domain/repositories/answer_notification_repository.dart';
import '../../domain/repositories/llm_repository.dart';
import '../../domain/repositories/passage_repository.dart';
import '../../domain/repositories/pending_question_repository.dart';
import '../../domain/repositories/prebuilt_answer_repository.dart';
import '../../domain/repositories/question_bank_repository.dart';
import '../../domain/repositories/question_history_repository.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/repositories/saved_answers_repository.dart';
import '../../domain/repositories/tutor_connection_repository.dart';
import '../../domain/repositories/tutor_scope_repository.dart';
import '../../domain/repositories/tutor_usage_repository.dart';
import '../../domain/services/prompt_builder.dart';
import '../../domain/usecases/ask_tutor_usecase.dart';
import '../../domain/usecases/delete_pending_question_usecase.dart';
import '../../domain/usecases/delete_saved_answer_usecase.dart';
import '../../domain/usecases/flush_pending_reports_usecase.dart';
import '../../domain/usecases/follow_up_usecase.dart';
import '../../domain/usecases/generate_answer_usecase.dart';
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

/// Use cases of the tutor feature.
class TutorUseCaseBinding extends Bindings {
  @override
  void dependencies() {
    int? grade() => Get.find<SettingsService>().grade.value;
    const promptBuilder = PromptBuilder();

    Get.lazyPut(
      () => GenerateAnswerUseCase(
        connection: Get.find<TutorConnectionRepository>(),
        usage: Get.find<TutorUsageRepository>(),
        llm: Get.find<LlmRepository>(),
        pending: Get.find<PendingQuestionRepository>(),
        history: Get.find<QuestionHistoryRepository>(),
        promptBuilder: promptBuilder,
        grade: grade,
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => AskTutorUseCase(
        scope: Get.find<TutorScopeRepository>(),
        bank: Get.find<QuestionBankRepository>(),
        passages: Get.find<PassageRepository>(),
        history: Get.find<QuestionHistoryRepository>(),
        generate: Get.find<GenerateAnswerUseCase>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetQuickAnswerUseCase(
        scope: Get.find<TutorScopeRepository>(),
        prebuilt: Get.find<PrebuiltAnswerRepository>(),
        passages: Get.find<PassageRepository>(),
        generate: Get.find<GenerateAnswerUseCase>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => FollowUpUseCase(Get.find<GenerateAnswerUseCase>()),
        fenix: true);
    Get.lazyPut(
      () => ProcessPendingQuestionsUseCase(
        pending: Get.find<PendingQuestionRepository>(),
        passages: Get.find<PassageRepository>(),
        llm: Get.find<LlmRepository>(),
        usage: Get.find<TutorUsageRepository>(),
        connection: Get.find<TutorConnectionRepository>(),
        history: Get.find<QuestionHistoryRepository>(),
        notifications: Get.find<AnswerNotificationRepository>(),
        promptBuilder: promptBuilder,
        grade: grade,
      ),
      fenix: true,
    );
    Get.lazyPut(() => StopGenerationUseCase(Get.find<LlmRepository>()),
        fenix: true);
    Get.lazyPut(
        () => ObserveTutorConnectionUseCase(
            Get.find<TutorConnectionRepository>()),
        fenix: true);
    Get.lazyPut(
        () =>
            ObserveAnswerTapsUseCase(Get.find<AnswerNotificationRepository>()),
        fenix: true);
    Get.lazyPut(
        () => RequestAnswerNotificationsUseCase(
            Get.find<AnswerNotificationRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetExampleQuestionsUseCase(Get.find<QuestionBankRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetPendingQuestionsUseCase(Get.find<PendingQuestionRepository>()),
        fenix: true);
    Get.lazyPut(
        () =>
            DeletePendingQuestionUseCase(Get.find<PendingQuestionRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetHistoryItemUseCase(Get.find<QuestionHistoryRepository>()),
        fenix: true);
    Get.lazyPut(() => SaveAnswerUseCase(Get.find<SavedAnswersRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetSavedAnswersUseCase(Get.find<SavedAnswersRepository>()),
        fenix: true);
    Get.lazyPut(
        () => DeleteSavedAnswerUseCase(Get.find<SavedAnswersRepository>()),
        fenix: true);
    Get.lazyPut(
        () => GetQuestionHistoryUseCase(Get.find<QuestionHistoryRepository>()),
        fenix: true);
    Get.lazyPut(() => SubmitReportUseCase(Get.find<ReportRepository>()),
        fenix: true);
    Get.lazyPut(() => FlushPendingReportsUseCase(Get.find<ReportRepository>()),
        fenix: true);
  }
}
