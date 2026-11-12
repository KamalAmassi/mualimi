import 'package:get/get.dart';

import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/device_capability_service.dart';
import '../../../../core/services/model_runtime.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../../subjects/domain/usecases/get_subject_detail_usecase.dart';
import '../../../subjects/domain/usecases/get_subjects_usecase.dart';
import '../../data/datasources/chunk_search_data_source.dart';
import '../../data/datasources/embedding_data_source.dart';
import '../../data/datasources/gemma_embedding_data_source.dart';
import '../../data/datasources/gemma_llm_data_source.dart';
import '../../data/datasources/gemma_runtime.dart';
import '../../data/datasources/llm_data_source.dart';
import '../../data/datasources/question_history_local_data_source.dart';
import '../../data/datasources/report_local_data_source.dart';
import '../../data/datasources/report_remote_data_source.dart';
import '../../data/datasources/saved_answers_local_data_source.dart';
import '../../data/datasources/sqlite_chunk_search_data_source.dart';
import '../../data/datasources/tutor_content_local_data_source.dart';
import '../../data/repositories/llm_repository_impl.dart';
import '../../data/repositories/prebuilt_answer_repository_impl.dart';
import '../../data/repositories/question_history_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/retrieval_repository_impl.dart';
import '../../data/repositories/saved_answers_repository_impl.dart';
import '../../data/repositories/tutor_scope_repository_impl.dart';
import '../../domain/repositories/llm_repository.dart';
import '../../domain/repositories/prebuilt_answer_repository.dart';
import '../../domain/repositories/question_history_repository.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/repositories/retrieval_repository.dart';
import '../../domain/repositories/saved_answers_repository.dart';
import '../../domain/repositories/tutor_scope_repository.dart';
import '../../domain/usecases/add_question_history_usecase.dart';
import '../../domain/usecases/ask_tutor_usecase.dart';
import '../../domain/usecases/build_prompt_usecase.dart';
import '../../domain/usecases/delete_saved_answer_usecase.dart';
import '../../domain/usecases/flush_pending_reports_usecase.dart';
import '../../domain/usecases/get_question_history_usecase.dart';
import '../../domain/usecases/get_saved_answers_usecase.dart';
import '../../domain/usecases/quick_action_usecase.dart';
import '../../domain/usecases/retrieve_chunks_usecase.dart';
import '../../domain/usecases/save_answer_usecase.dart';
import '../../domain/usecases/stop_generation_usecase.dart';
import '../../domain/usecases/submit_report_usecase.dart';
import '../controllers/lesson_picker_controller.dart';
import '../controllers/report_controller.dart';
import '../controllers/saved_controller.dart';
import '../controllers/tutor_controller.dart';

/// Wires the whole tutor feature. Used by the shell (chat tab) and /saved.
class TutorBinding extends Bindings {
  @override
  void dependencies() {
    final databases = Get.find<DatabaseService>();
    final runtime = Get.find<ModelRuntime>() as GemmaRuntime;

    // Every data source sits behind an interface.
    final content = TutorContentLocalDataSource(databases);
    final ChunkSearchDataSource search = SqliteChunkSearchDataSource(databases);
    final EmbeddingDataSource embeddings = GemmaEmbeddingDataSource(
        runtime.bootstrap, Get.find<AppPathsService>(), Get.find<SettingsService>());
    final LlmDataSource llm = GemmaLlmDataSource(runtime, Get.find<TutorEngineService>());

    Get.lazyPut<TutorScopeRepository>(() => TutorScopeRepositoryImpl(content), fenix: true);
    Get.lazyPut<RetrievalRepository>(() => RetrievalRepositoryImpl(search, embeddings), fenix: true);
    Get.lazyPut<LlmRepository>(() => LlmRepositoryImpl(llm), fenix: true);
    Get.lazyPut<PrebuiltAnswerRepository>(() => PrebuiltAnswerRepositoryImpl(content), fenix: true);
    Get.lazyPut<SavedAnswersRepository>(
        () => SavedAnswersRepositoryImpl(SavedAnswersLocalDataSource(databases.user)),
        fenix: true);
    Get.lazyPut<QuestionHistoryRepository>(
        () => QuestionHistoryRepositoryImpl(QuestionHistoryLocalDataSource(databases.user)),
        fenix: true);
    Get.lazyPut<ReportRepository>(
        () => ReportRepositoryImpl(
            ReportLocalDataSource(databases.user), UnconfiguredReportRemoteDataSource()),
        fenix: true);

    Get.lazyPut(() => RetrieveChunksUseCase(Get.find<RetrievalRepository>()), fenix: true);
    Get.lazyPut(
      () => AskTutorUseCase(
        scope: Get.find<TutorScopeRepository>(),
        retrieve: Get.find<RetrieveChunksUseCase>(),
        buildPrompt: const BuildPromptUseCase(),
        llm: Get.find<LlmRepository>(),
        deviceTier: () => Get.find<DeviceCapabilityService>().tier,
      ),
      fenix: true,
    );
    Get.lazyPut(
        () => QuickActionUseCase(Get.find<PrebuiltAnswerRepository>(), Get.find<AskTutorUseCase>()),
        fenix: true);
    Get.lazyPut(() => StopGenerationUseCase(Get.find<LlmRepository>()), fenix: true);
    Get.lazyPut(() => SaveAnswerUseCase(Get.find<SavedAnswersRepository>()), fenix: true);
    Get.lazyPut(() => GetSavedAnswersUseCase(Get.find<SavedAnswersRepository>()), fenix: true);
    Get.lazyPut(() => DeleteSavedAnswerUseCase(Get.find<SavedAnswersRepository>()), fenix: true);
    Get.lazyPut(() => AddQuestionHistoryUseCase(Get.find<QuestionHistoryRepository>()), fenix: true);
    Get.lazyPut(() => GetQuestionHistoryUseCase(Get.find<QuestionHistoryRepository>()), fenix: true);
    Get.lazyPut(() => SubmitReportUseCase(Get.find<ReportRepository>()), fenix: true);
    Get.lazyPut(() => FlushPendingReportsUseCase(Get.find<ReportRepository>()), fenix: true);

    Get.lazyPut(
      () => TutorController(
        ask: Get.find<AskTutorUseCase>(),
        quick: Get.find<QuickActionUseCase>(),
        stop: Get.find<StopGenerationUseCase>(),
        addHistory: Get.find<AddQuestionHistoryUseCase>(),
        saveAnswer: Get.find<SaveAnswerUseCase>(),
        flushReports: Get.find<FlushPendingReportsUseCase>(),
        engine: Get.find<TutorEngineService>(),
        connectivity: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => LessonPickerController(
        Get.find<GetSubjectsUseCase>(),
        Get.find<GetSubjectDetailUseCase>(),
        Get.find<TutorController>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => ReportController(Get.find<SubmitReportUseCase>()), fenix: true);
    Get.lazyPut(() => SavedController(
          Get.find<GetSavedAnswersUseCase>(),
          Get.find<GetQuestionHistoryUseCase>(),
          Get.find<DeleteSavedAnswerUseCase>(),
        ));
  }
}
