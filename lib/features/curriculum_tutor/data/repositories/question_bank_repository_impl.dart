import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/bank_match.dart';
import '../../domain/repositories/question_bank_repository.dart';
import '../../domain/services/question_bank_matcher.dart';
import '../datasources/question_bank_local_data_source.dart';

class QuestionBankRepositoryImpl implements QuestionBankRepository {
  QuestionBankRepositoryImpl(this._local, this._matcher);

  final QuestionBankLocalDataSource _local;
  final QuestionBankMatcher _matcher;

  @override
  Future<Either<Failure, BankMatch?>> findMatch(
    String normalizedQuestion, {
    required String subjectId,
  }) async {
    try {
      final candidates =
          await _local.candidates(normalizedQuestion, subjectId: subjectId);
      return Right(_matcher.best(normalizedQuestion, candidates));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<List<String>> exampleQuestions(
    String subjectId, {
    String? lessonId,
    int limit = 3,
  }) async {
    try {
      return await _local.exampleQuestions(subjectId,
          lessonId: lessonId, limit: limit);
    } on DatabaseException {
      return const [];
    }
  }
}
