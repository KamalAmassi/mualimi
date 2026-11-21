import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_arabic_skills.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_gap_filling.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_g9.dart';
import 'package:mualimi/core/db/content/seed/dev_seed_science_skills_charges.dart';
import 'package:mualimi/core/usecase/usecase.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_answer.dart';
import 'package:mualimi/features/gap_filling/domain/entities/diagnostic_session.dart';
import 'package:mualimi/features/gap_filling/domain/entities/mastery_source.dart';
import 'package:mualimi/features/gap_filling/domain/entities/question_kind.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/finish_diagnostic_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/save_diagnostic_answers_usecase.dart';
import 'package:mualimi/features/gap_filling/domain/usecases/submit_skill_review_usecase.dart';

import 'gap_filling_harness.dart';

T _right<T>(Either<Object, T> either) =>
    either.fold((l) => throw StateError('$l'), (r) => r);

void main() {
  final h = GapFillingHarness();
  setUp(h.open);
  tearDown(h.close);

  Future<DiagnosticSession> startSession() async =>
      _right(await h.start(const NoParams()));

  Map<int, DiagnosticAnswer> answerAll(DiagnosticSession s, {required bool right}) => {
        for (final plan in s.plans)
          for (final q in plan.questions)
            q.id: DiagnosticAnswer(
                questionId: q.id, choiceIndex: right ? q.answerIndex : null),
      };

  group('catalog', () {
    test('needs count the installed lessons that depend on each skill', () async {
      final needs = _right(await h.catalog.getSkillNeeds());
      final counts = {for (final n in needs) n.skill.id: n.lessonCount};
      expect(counts[chargesSkillId], 2);
      expect(counts[atomSkillId], 1);
      expect(counts.length, 8);
    });

    test('the charging lesson needs the atom and charges skills', () async {
      final needs =
          _right(await h.catalog.getLessonNeeds(DevSeedScienceG9.lessonId));
      expect(needs.map((n) => n.skill.id),
          containsAll([atomSkillId, chargesSkillId]));
      final charges = needs.firstWhere((n) => n.skill.id == chargesSkillId);
      expect(charges.lessonCount, 2);
    });

    test('a lesson without prerequisites has no needs', () async {
      final needs =
          _right(await h.catalog.getLessonNeeds(DevSeedScienceG9.mathLessonId));
      expect(needs, isEmpty);
    });

    test('questions are filtered by kind and skill', () async {
      final review = _right(await h.catalog
          .getQuestions(QuestionKind.review, skillId: atomSkillId));
      expect(review.length, 2);
      expect(review.every((q) => q.kind == QuestionKind.review), isTrue);
      final all = _right(await h.catalog.getQuestions(QuestionKind.diagnostic));
      expect(all.length, 16);
    });

    test('an unknown skill is a database failure', () async {
      expect((await h.catalog.getSkill('missing')).isLeft(), isTrue);
    });
  });

  group('diagnostic plans', () {
    test('science and Arabic have a diagnostic, math has no skills', () async {
      final plans = _right(await h.plans(const NoParams()));
      expect(plans.map((p) => p.subjectId), ['science', 'arabic']);
      expect(plans.first.questions.length, 10);
      expect(plans.last.questions.length, 6);
    });
  });

  group('diagnostic run', () {
    test('starting twice resumes the same attempts and their answers', () async {
      final first = await startSession();
      final question = first.plans.first.questions.first;
      final attempt = first.attempts['science']!;
      await h.saveAnswers(SaveDiagnosticAnswersParams(
          attempt.id, [DiagnosticAnswer(questionId: question.id, choiceIndex: 2)]));

      final second = await startSession();
      expect(second.attempts['science']!.id, attempt.id);
      expect(second.answered.keys, [question.id]);
      expect(second.answered[question.id]!.choiceIndex, 2);
    });

    test('an unknown answer is stored and read back as null', () async {
      final session = await startSession();
      final q = session.plans.first.questions.first;
      await h.saveAnswers(SaveDiagnosticAnswersParams(
          session.attempts['science']!.id,
          [DiagnosticAnswer(questionId: q.id)]));
      final resumed = await startSession();
      expect(resumed.answered[q.id], DiagnosticAnswer(questionId: q.id));
    });

    test('finishing with right answers leaves nothing weak', () async {
      final session = await startSession();
      final results = _right(await h.finish(
          FinishDiagnosticParams(session, answerAll(session, right: true))));
      expect(results.every((r) => r.weakSkills.isEmpty), isTrue);
      expect(results.first.strongSkillCount, 5);
      final path = _right(await h.path(const NoParams()));
      expect(path.diagnosticTaken, isTrue);
      expect(path.weakSkills, isEmpty);
    });

    test('finishing with unknown answers makes every asked skill weak, in order',
        () async {
      final session = await startSession();
      final results = _right(await h.finish(
          FinishDiagnosticParams(session, answerAll(session, right: false))));
      expect(results.first.weakSkills.first.id, chargesSkillId);
      final path = _right(await h.path(const NoParams()));
      expect(path.weakSkills.length, 8);
      expect(path.shown.length, 3);
      expect(path.shown.first.id, chargesSkillId);
    });

    test('finished attempts are closed, so the next start is a new diagnostic',
        () async {
      final session = await startSession();
      _right(await h.finish(
          FinishDiagnosticParams(session, answerAll(session, right: false))));
      expect(_right(await h.progress.getUnfinishedAttempts()), isEmpty);
      final again = await startSession();
      expect(again.answered, isEmpty);
      expect(again.attempts['science']!.id, isNot(session.attempts['science']!.id));
    });

    test('a retake replaces the old scores', () async {
      final first = await startSession();
      _right(await h.finish(
          FinishDiagnosticParams(first, answerAll(first, right: false))));
      final retake = await startSession();
      _right(await h.finish(
          FinishDiagnosticParams(retake, answerAll(retake, right: true))));
      expect(_right(await h.path(const NoParams())).weakSkills, isEmpty);
      final mastery = _right(await h.progress.getMastery());
      expect(mastery.length, 8);
      expect(mastery.every((m) => m.score == 100), isTrue);
    });

    test('no diagnostic yet means the path is not taken', () async {
      final path = _right(await h.path(const NoParams()));
      expect(path.diagnosticTaken, isFalse);
      expect(path.weakSkills, isEmpty);
    });

    test('a skipped diagnostic with open attempts is not taken', () async {
      await startSession();
      expect(_right(await h.path(const NoParams())).diagnosticTaken, isFalse);
    });
  });

  group('lesson card and review', () {
    Future<void> everythingWeak() async {
      final session = await startSession();
      _right(await h.finish(
          FinishDiagnosticParams(session, answerAll(session, right: false))));
    }

    test('only weak prerequisites of the lesson are listed', () async {
      await everythingWeak();
      final skills =
          _right(await h.lessonPrerequisites(DevSeedScienceG9.lessonId));
      expect(skills.map((s) => s.id).toSet(),
          {atomSkillId, chargesSkillId, conductorsSkillId});
    });

    test('before any diagnostic the lesson list is empty', () async {
      expect(_right(await h.lessonPrerequisites(DevSeedScienceG9.lessonId)),
          isEmpty);
    });

    test('a review loads the skill and its review questions only', () async {
      final loaded = _right(await h.review(atomSkillId));
      expect(loaded.skill.title, 'تركيب الذرة');
      expect(loaded.questions.length, 2);
      expect(loaded.questions.every((q) => q.kind == QuestionKind.review), isTrue);
    });

    test('a good review removes the skill from the path and the lesson card',
        () async {
      await everythingWeak();
      final outcome = _right(await h.submit(const SubmitSkillReviewParams(
          skillId: atomSkillId, correct: 2, asked: 2)));
      expect(outcome.stillWeak, isFalse);
      expect(outcome.score, 100);
      final path = _right(await h.path(const NoParams()));
      expect(path.weakSkills.map((s) => s.id), isNot(contains(atomSkillId)));
      final card = _right(await h.lessonPrerequisites(DevSeedScienceG9.lessonId));
      expect(card.map((s) => s.id), isNot(contains(atomSkillId)));
      final stored = _right(await h.progress.getMastery())
          .firstWhere((m) => m.skillId == atomSkillId);
      expect(stored.source, MasterySource.review);
    });

    test('a poor review keeps the skill weak and never lowers a score', () async {
      await everythingWeak();
      _right(await h.submit(const SubmitSkillReviewParams(
          skillId: atomSkillId, correct: 1, asked: 2)));
      final outcome = _right(await h.submit(const SubmitSkillReviewParams(
          skillId: atomSkillId, correct: 0, asked: 2)));
      expect(outcome.score, 50);
      expect(outcome.stillWeak, isTrue);
      expect(
          _right(await h.path(const NoParams())).weakSkills.map((s) => s.id),
          contains(atomSkillId));
    });

    test('the Arabic lesson depends on the three Arabic skills', () async {
      final needs =
          _right(await h.catalog.getLessonNeeds(DevSeedGapFilling.arabicLessonId));
      expect(needs.map((n) => n.skill.id).toSet(), {
        partsOfSpeechSkillId,
        subjectPredicateSkillId,
        verbTensesSkillId,
      });
    });
  });
}
