import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/llm_prompt.dart';
import '../../domain/repositories/llm_repository.dart';
import '../datasources/llm_data_source.dart';

class LlmRepositoryImpl implements LlmRepository {
  LlmRepositoryImpl(this._source);
  final LlmDataSource _source;

  @override
  bool get wasStopped => _source.wasStopped;

  @override
  Stream<Either<Failure, String>> streamAnswer(LlmPrompt prompt) async* {
    try {
      await for (final text in _source.streamAnswer(prompt)) {
        yield Right(text);
      }
    } on AppException catch (e) {
      yield Left(_failure(e));
    }
  }

  @override
  Future<Either<Failure, String>> answer(LlmPrompt prompt) async {
    try {
      return Right(await _source.generate(prompt));
    } on AppException catch (e) {
      return Left(_failure(e));
    }
  }

  @override
  Future<void> stop() => _source.stop();

  Failure _failure(AppException e) =>
      e is NetworkException ? NetworkFailure(e.message) : LlmFailure(e.message);
}
