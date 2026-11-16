import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/passage.dart';

abstract class PassageRepository {
  /// Best pack passages for [normalizedQuestion], strongest first. With a
  /// [lessonId] the lesson is searched first and the whole subject is the
  /// fallback when the lesson has no match.
  Future<Either<Failure, List<Passage>>> search(
    String normalizedQuestion, {
    required String subjectId,
    String? lessonId,
  });

  /// Passages by id, in the order given; unknown ids are skipped.
  Future<Either<Failure, List<Passage>>> findByIds(List<int> ids);

  /// The lesson's passages in book order, cut off once [maxChars] is reached.
  Future<Either<Failure, List<Passage>>> lessonPassages(String lessonId,
      {required int maxChars});
}
