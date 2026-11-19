import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/mastery_source.dart';
import '../entities/review_outcome.dart';
import '../entities/skill_mastery.dart';
import '../repositories/skill_progress_repository.dart';
import '../rules/review_scorer.dart';

class SubmitSkillReviewParams extends Equatable {
  const SubmitSkillReviewParams(
      {required this.skillId, required this.correct, required this.asked});

  final String skillId;
  final int correct;
  final int asked;

  @override
  List<Object?> get props => [skillId, correct, asked];
}

/// Records the result of a mini review. The score never goes down.
class SubmitSkillReviewUseCase
    implements UseCase<ReviewOutcome, SubmitSkillReviewParams> {
  SubmitSkillReviewUseCase(this._progress, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final SkillProgressRepository _progress;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, ReviewOutcome>> call(
      SubmitSkillReviewParams params) async {
    final stored = await _progress.getMastery();
    return stored.fold((failure) async => Left(failure), (all) async {
      final old = all.where((m) => m.skillId == params.skillId).firstOrNull;
      final score = ReviewScorer.nextScore(
          old: old?.score, correct: params.correct, asked: params.asked);
      final saved = await _progress.saveMastery(SkillMastery(
        skillId: params.skillId,
        score: score,
        source: MasterySource.review,
        updatedAt: _now(),
      ));
      return saved.map(
          (_) => ReviewOutcome(score: score, stillWeak: ReviewScorer.isWeak(score)));
    });
  }
}
