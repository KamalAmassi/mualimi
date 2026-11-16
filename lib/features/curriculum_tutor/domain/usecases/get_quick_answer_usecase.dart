import 'package:equatable/equatable.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/answer_source.dart';
import '../entities/passage.dart';
import '../entities/quick_action.dart';
import '../entities/tutor_answer.dart';
import '../entities/tutor_event.dart';
import '../repositories/passage_repository.dart';
import '../repositories/prebuilt_answer_repository.dart';
import '../repositories/tutor_scope_repository.dart';
import 'generate_answer_params.dart';
import 'generate_answer_usecase.dart';

class QuickAnswerParams extends Equatable {
  const QuickAnswerParams({
    required this.lessonId,
    required this.subjectId,
    required this.action,
  });

  final String lessonId;
  final String subjectId;
  final QuickAction action;

  @override
  List<Object?> get props => [lessonId, subjectId, action];
}

/// Explain, summary or key terms of a lesson: the pack's prebuilt answer when
/// it has one (offline, no quota), otherwise a cloud answer from the whole lesson.
class GetQuickAnswerUseCase
    implements StreamUseCase<TutorEvent, QuickAnswerParams> {
  GetQuickAnswerUseCase({
    required TutorScopeRepository scope,
    required PrebuiltAnswerRepository prebuilt,
    required PassageRepository passages,
    required GenerateAnswerUseCase generate,
  })  : _scope = scope,
        _prebuilt = prebuilt,
        _passages = passages,
        _generate = generate;

  final TutorScopeRepository _scope;
  final PrebuiltAnswerRepository _prebuilt;
  final PassageRepository _passages;
  final GenerateAnswerUseCase _generate;

  @override
  Stream<TutorEvent> call(QuickAnswerParams params) async* {
    if (!await _scope.isTutorEnabled(params.subjectId,
        lessonId: params.lessonId)) {
      yield const TutorSubjectUnsupported();
      return;
    }
    final lesson = (await _passages.lessonPassages(params.lessonId,
            maxChars: Limits.maxLessonChars))
        .getOrElse(() => const <Passage>[]);

    final stored = await _prebuilt.find(params.lessonId, params.action);
    if (stored != null) {
      yield TutorBankAnswer(TutorAnswer(
        text: stored,
        source: lesson.isEmpty ? null : AnswerSource.fromPassage(lesson.first),
        fromBank: true,
      ));
      return;
    }
    if (lesson.isEmpty) {
      yield const TutorOutOfScope();
      return;
    }
    yield* _generate(GenerateAnswerParams(
      question: params.action.instruction,
      subjectId: params.subjectId,
      lessonId: params.lessonId,
      passages: lesson,
      queueWhenOffline: false,
      recordHistory: false,
    ));
  }
}
