import '../../../../core/usecase/usecase.dart';
import '../entities/answer_source.dart';
import '../entities/quick_action.dart';
import '../entities/tutor_event.dart';
import '../repositories/prebuilt_answer_repository.dart';
import 'ask_tutor_params.dart';
import 'ask_tutor_usecase.dart';

class QuickActionParams {
  const QuickActionParams({required this.action, required this.subjectId, required this.lessonId});
  final QuickAction action;
  final String subjectId;
  final String lessonId;
}

/// Explain / summarize / key terms: a prebuilt answer if the pack has one
/// (instant, no model), otherwise the normal pipeline with a canned question.
class QuickActionUseCase implements StreamUseCase<TutorEvent, QuickActionParams> {
  QuickActionUseCase(this._prebuilt, this._ask);
  final PrebuiltAnswerRepository _prebuilt;
  final AskTutorUseCase _ask;

  @override
  Stream<TutorEvent> call(QuickActionParams p) async* {
    final prebuilt = await _prebuilt.find(p.lessonId, p.action);
    if (prebuilt != null) {
      yield TutorToken(prebuilt);
      yield TutorDone(AnswerSource(lessonId: p.lessonId, page: 0));
      return;
    }
    yield* _ask(AskTutorParams(
      question: p.action.question,
      subjectId: p.subjectId,
      lessonId: p.lessonId,
    ));
  }
}
