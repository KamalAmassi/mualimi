import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/bank_match.dart';

abstract class QuestionBankRepository {
  /// The stored question that best matches [normalizedQuestion] in the
  /// subject, or null when none is close enough.
  Future<Either<Failure, BankMatch?>> findMatch(
    String normalizedQuestion, {
    required String subjectId,
  });

  /// Up to [limit] stored questions to suggest to the student: the lesson's
  /// when [lessonId] is given and has some, otherwise the subject's.
  Future<List<String>> exampleQuestions(
    String subjectId, {
    String? lessonId,
    int limit = 3,
  });
}
