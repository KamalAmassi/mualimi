import 'package:get/get.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../data/datasources/content_access.dart';
import '../../data/datasources/flutter_local_notification_data_source.dart';
import '../../data/datasources/gemini_client.dart';
import '../../data/datasources/llm_data_source.dart';
import '../../data/datasources/local_notification_data_source.dart';
import '../../data/datasources/passage_search_data_source.dart';
import '../../data/datasources/pending_question_local_data_source.dart';
import '../../data/datasources/question_bank_local_data_source.dart';
import '../../data/datasources/question_history_local_data_source.dart';
import '../../data/datasources/report_local_data_source.dart';
import '../../data/datasources/report_remote_data_source.dart';
import '../../data/datasources/saved_answers_local_data_source.dart';
import '../../data/datasources/tutor_content_local_data_source.dart';
import '../../data/datasources/tutor_usage_local_data_source.dart';
import '../../data/repositories/answer_notification_repository_impl.dart';
import '../../data/repositories/llm_repository_impl.dart';
import '../../data/repositories/passage_repository_impl.dart';
import '../../data/repositories/pending_question_repository_impl.dart';
import '../../data/repositories/prebuilt_answer_repository_impl.dart';
import '../../data/repositories/question_bank_repository_impl.dart';
import '../../data/repositories/question_history_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/repositories/saved_answers_repository_impl.dart';
import '../../data/repositories/tutor_connection_repository_impl.dart';
import '../../data/repositories/tutor_scope_repository_impl.dart';
import '../../data/repositories/tutor_usage_repository_impl.dart';
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
import '../../domain/services/question_bank_matcher.dart';

/// Data sources and repositories of the tutor feature.
class TutorDataBinding extends Bindings {
  @override
  void dependencies() {
    final databases = Get.find<DatabaseService>();
    final content = ContentAccess(() => databases.content);
    final tutorContent = TutorContentLocalDataSource(content);

    final LlmDataSource llm = GeminiClient();
    final LocalNotificationDataSource notifications =
        FlutterLocalNotificationDataSource();

    Get.lazyPut<TutorScopeRepository>(
        () => TutorScopeRepositoryImpl(tutorContent),
        fenix: true);
    Get.lazyPut<PrebuiltAnswerRepository>(
        () => PrebuiltAnswerRepositoryImpl(tutorContent),
        fenix: true);
    Get.lazyPut<PassageRepository>(
        () => PassageRepositoryImpl(PassageSearchDataSource(content)),
        fenix: true);
    Get.lazyPut<QuestionBankRepository>(
        () => QuestionBankRepositoryImpl(
            QuestionBankLocalDataSource(content), const QuestionBankMatcher()),
        fenix: true);
    Get.lazyPut<LlmRepository>(() => LlmRepositoryImpl(llm), fenix: true);
    Get.lazyPut<TutorConnectionRepository>(
        () => TutorConnectionRepositoryImpl(
            Get.find<TutorEngineService>(), Get.find<ConnectivityService>()),
        fenix: true);
    Get.lazyPut<TutorUsageRepository>(
        () =>
            TutorUsageRepositoryImpl(TutorUsageLocalDataSource(databases.user)),
        fenix: true);
    Get.lazyPut<PendingQuestionRepository>(
        () => PendingQuestionRepositoryImpl(
            PendingQuestionLocalDataSource(databases.user)),
        fenix: true);
    Get.lazyPut<AnswerNotificationRepository>(
        () => AnswerNotificationRepositoryImpl(notifications),
        fenix: true);
    Get.lazyPut<SavedAnswersRepository>(
        () => SavedAnswersRepositoryImpl(
            SavedAnswersLocalDataSource(databases.user)),
        fenix: true);
    Get.lazyPut<QuestionHistoryRepository>(
        () => QuestionHistoryRepositoryImpl(
            QuestionHistoryLocalDataSource(databases.user)),
        fenix: true);
    Get.lazyPut<ReportRepository>(
        () => ReportRepositoryImpl(ReportLocalDataSource(databases.user),
            UnconfiguredReportRemoteDataSource()),
        fenix: true);
  }
}
