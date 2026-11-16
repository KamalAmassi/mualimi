import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/follow_up.dart';
import '../entities/passage.dart';
import '../entities/tutor_event.dart';
import 'generate_answer_params.dart';
import 'generate_answer_usecase.dart';

class FollowUpParams extends Equatable {
  const FollowUpParams({
    required this.followUp,
    required this.question,
    required this.previousAnswer,
    required this.subjectId,
    required this.passages,
    this.lessonId,
  });

  final FollowUp followUp;
  final String question;
  final String previousAnswer;
  final String subjectId;
  final String? lessonId;
  final List<Passage> passages;

  @override
  List<Object?> get props =>
      [followUp, question, previousAnswer, subjectId, lessonId, passages];
}

/// "Explain more", "give an example" and "bullet points": a new request with
/// the same passages, the previous answer and the follow-up instruction.
class FollowUpUseCase implements StreamUseCase<TutorEvent, FollowUpParams> {
  FollowUpUseCase(this._generate);
  final GenerateAnswerUseCase _generate;

  @override
  Stream<TutorEvent> call(FollowUpParams params) =>
      _generate(GenerateAnswerParams(
        question: params.question,
        subjectId: params.subjectId,
        lessonId: params.lessonId,
        passages: params.passages,
        previousAnswer: params.previousAnswer,
        followUpInstruction: params.followUp.instruction,
        queueWhenOffline: false,
        recordHistory: false,
      ));
}
