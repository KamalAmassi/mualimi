import '../../domain/usecases/ask_tutor_usecase.dart';
import '../../domain/usecases/delete_pending_question_usecase.dart';
import '../../domain/usecases/flush_pending_reports_usecase.dart';
import '../../domain/usecases/follow_up_usecase.dart';
import '../../domain/usecases/get_example_questions_usecase.dart';
import '../../domain/usecases/get_quick_answer_usecase.dart';
import '../../domain/usecases/request_answer_notifications_usecase.dart';
import '../../domain/usecases/save_answer_usecase.dart';
import '../../domain/usecases/stop_generation_usecase.dart';

/// The use cases the chat tab calls, passed to its controller as one unit.
class TutorUseCases {
  const TutorUseCases({
    required this.ask,
    required this.quick,
    required this.followUp,
    required this.stop,
    required this.saveAnswer,
    required this.deletePending,
    required this.getExamples,
    required this.requestNotifications,
    required this.flushReports,
  });

  final AskTutorUseCase ask;
  final GetQuickAnswerUseCase quick;
  final FollowUpUseCase followUp;
  final StopGenerationUseCase stop;
  final SaveAnswerUseCase saveAnswer;
  final DeletePendingQuestionUseCase deletePending;
  final GetExampleQuestionsUseCase getExamples;
  final RequestAnswerNotificationsUseCase requestNotifications;
  final FlushPendingReportsUseCase flushReports;
}
