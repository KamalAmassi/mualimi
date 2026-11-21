import 'package:get/get.dart';

import '../../domain/entities/diagnostic_question.dart';
import '../../domain/entities/review_outcome.dart';
import '../../domain/entities/skill_review.dart';
import '../../domain/usecases/get_skill_review_usecase.dart';
import '../../domain/usecases/submit_skill_review_usecase.dart';
import '../routes/skill_review_args.dart';
import 'skill_progress_signal.dart';

enum SkillReviewStage { loading, lesson, question, result, failed }

class SkillReviewController extends GetxController {
  SkillReviewController(this._getReview, this._submit, this._signal,
      {required this.args});

  final GetSkillReviewUseCase _getReview;
  final SubmitSkillReviewUseCase _submit;
  final SkillProgressSignal _signal;
  final SkillReviewArgs? args;

  final stage = SkillReviewStage.loading.obs;
  final review = Rxn<SkillReview>();
  final questionIndex = 0.obs;

  /// The choice the student just made; feedback shows while it is set.
  final picked = Rxn<int>();
  final outcome = Rxn<ReviewOutcome>();
  int _correct = 0;

  DiagnosticQuestion get question =>
      review.value!.questions[questionIndex.value];

  bool get isLastQuestion =>
      questionIndex.value + 1 >= review.value!.questions.length;

  bool get opensFromLesson => args?.lessonId != null;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final skillId = args?.skillId;
    if (skillId == null) {
      stage.value = SkillReviewStage.failed;
      return;
    }
    stage.value = SkillReviewStage.loading;
    final loaded = await _getReview(skillId);
    loaded.fold((_) => stage.value = SkillReviewStage.failed, (found) {
      review.value = found;
      stage.value = SkillReviewStage.lesson;
    });
  }

  void startQuestions() {
    if (review.value!.questions.isEmpty) {
      finish();
      return;
    }
    questionIndex.value = 0;
    picked.value = null;
    _correct = 0;
    stage.value = SkillReviewStage.question;
  }

  void answer(int index) {
    if (picked.value != null) return;
    picked.value = index;
    if (question.isCorrect(index)) _correct++;
  }

  Future<void> next() async {
    if (picked.value == null) return;
    if (isLastQuestion) return finish();
    questionIndex.value++;
    picked.value = null;
  }

  Future<void> finish() async {
    final current = review.value!;
    final done = await _submit(SubmitSkillReviewParams(
      skillId: current.skill.id,
      correct: _correct,
      asked: current.questions.length,
    ));
    done.fold((_) => stage.value = SkillReviewStage.failed, (result) {
      outcome.value = result;
      _signal.changed();
      stage.value = SkillReviewStage.result;
    });
  }

  void reviewAgain() {
    picked.value = null;
    outcome.value = null;
    stage.value = SkillReviewStage.lesson;
  }

  void leave() => Get.back<void>();
}
