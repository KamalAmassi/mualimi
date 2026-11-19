import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/diagnostic_answer.dart';
import '../../domain/entities/diagnostic_question.dart';
import '../../domain/entities/diagnostic_session.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/subject_diagnostic.dart';
import '../../domain/entities/subject_diagnostic_result.dart';
import '../../domain/usecases/finish_diagnostic_usecase.dart';
import '../../domain/usecases/get_diagnostic_plans_usecase.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';
import '../../domain/usecases/save_diagnostic_answers_usecase.dart';
import '../../domain/usecases/start_diagnostic_usecase.dart';
import '../routes/diagnostic_args.dart';
import '../routes/skill_review_args.dart';
import 'diagnostic_stage.dart';
import 'skill_progress_signal.dart';

class DiagnosticController extends GetxController {
  DiagnosticController(
    this._getPlans,
    this._start,
    this._saveAnswers,
    this._finish,
    this._getPath,
    this._signal, {
    required this.entry,
  });

  final GetDiagnosticPlansUseCase _getPlans;
  final StartDiagnosticUseCase _start;
  final SaveDiagnosticAnswersUseCase _saveAnswers;
  final FinishDiagnosticUseCase _finish;
  final GetLearningPathUseCase _getPath;
  final SkillProgressSignal _signal;
  final DiagnosticEntry entry;

  final stage = DiagnosticStage.loading.obs;
  final plans = <SubjectDiagnostic>[].obs;
  final planIndex = 0.obs;
  final questionIndex = 0.obs;
  final selected = Rxn<int>();
  final results = <SubjectDiagnosticResult>[].obs;

  DiagnosticSession? _session;
  final _answers = <int, DiagnosticAnswer>{};
  bool _busy = false;

  /// Coming from onboarding, Back must never return to it; it leaves instead.
  bool get blocksBack => entry == DiagnosticEntry.onboarding;

  SubjectDiagnostic get currentPlan => plans[planIndex.value];

  DiagnosticQuestion get currentQuestion =>
      currentPlan.questions[questionIndex.value];

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    stage.value = DiagnosticStage.loading;
    final loaded = await _getPlans(const NoParams());
    loaded.fold((_) => stage.value = DiagnosticStage.failed, (found) {
      if (found.isEmpty) return leave();
      plans.assignAll(found);
      stage.value = DiagnosticStage.intro;
    });
  }

  Future<void> start() async {
    final started = await _start(const NoParams());
    final session = started.fold<DiagnosticSession?>((_) => null, (s) => s);
    if (session == null) {
      stage.value = DiagnosticStage.failed;
      return;
    }
    _session = session;
    _answers
      ..clear()
      ..addAll(session.answered);
    if (!_moveToFirstUnanswered()) return finish();
    stage.value = DiagnosticStage.question;
  }

  void choose(int index) => selected.value = index;

  Future<void> next() async {
    final choice = selected.value;
    if (choice != null) await _record(choice);
  }

  Future<void> skip() => _record(null);

  void continueFromDivider() => stage.value = DiagnosticStage.question;

  Future<void> finish() async {
    final session = _session;
    if (session == null) return;
    final done = await _finish(FinishDiagnosticParams(session, _answers));
    done.fold((_) => stage.value = DiagnosticStage.failed, (found) {
      results.assignAll(found);
      _signal.changed();
      stage.value = DiagnosticStage.result;
    });
  }

  Future<void> reviewSkill(Skill skill) async {
    await Get.toNamed(AppRoutes.skillReview,
        arguments: SkillReviewArgs(skillId: skill.id));
    await _dropStrengthened();
  }

  /// "Start studying" and "later" both end the diagnostic.
  void leave() {
    if (entry == DiagnosticEntry.onboarding) {
      Get.offAllNamed(AppRoutes.shell);
    } else {
      Get.back<void>();
    }
  }

  Future<void> _record(int? choice) async {
    if (_busy) return;
    _busy = true;
    try {
      _answers[currentQuestion.id] =
          DiagnosticAnswer(questionId: currentQuestion.id, choiceIndex: choice);
      selected.value = null;
      await _persist(currentPlan);
      if (questionIndex.value + 1 < currentPlan.questions.length) {
        questionIndex.value++;
      } else if (planIndex.value + 1 < plans.length) {
        planIndex.value++;
        questionIndex.value = 0;
        stage.value = DiagnosticStage.divider;
      } else {
        await finish();
      }
    } finally {
      _busy = false;
    }
  }

  Future<void> _persist(SubjectDiagnostic plan) async {
    final attempt = _session?.attempts[plan.subjectId];
    if (attempt == null) return;
    await _saveAnswers(SaveDiagnosticAnswersParams(attempt.id, [
      for (final q in plan.questions)
        if (_answers[q.id] != null) _answers[q.id]!,
    ]));
  }

  /// Resumes after the answers already given. False when everything is answered.
  bool _moveToFirstUnanswered() {
    for (final (p, plan) in plans.indexed) {
      for (final (q, question) in plan.questions.indexed) {
        if (_answers.containsKey(question.id)) continue;
        planIndex.value = p;
        questionIndex.value = q;
        return true;
      }
    }
    return false;
  }

  Future<void> _dropStrengthened() async {
    final path = await _getPath(const NoParams());
    path.fold((_) {}, (found) {
      final weak = {for (final s in found.weakSkills) s.id};
      results.assignAll([
        for (final r in results)
          SubjectDiagnosticResult(
            subjectId: r.subjectId,
            subjectName: r.subjectName,
            strongSkillCount: r.strongSkillCount,
            weakSkills: [for (final s in r.weakSkills) if (weak.contains(s.id)) s],
          ),
      ]);
    });
  }
}
