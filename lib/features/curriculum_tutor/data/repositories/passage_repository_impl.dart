import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/passage.dart';
import '../../domain/repositories/passage_repository.dart';
import '../datasources/passage_search_data_source.dart';

class PassageRepositoryImpl implements PassageRepository {
  PassageRepositoryImpl(this._search);
  final PassageSearchDataSource _search;

  @override
  Future<Either<Failure, List<Passage>>> search(
    String normalizedQuestion, {
    required String subjectId,
    String? lessonId,
  }) =>
      _guard(() => _search.search(normalizedQuestion,
          subjectId: subjectId, lessonId: lessonId));

  @override
  Future<Either<Failure, List<Passage>>> findByIds(List<int> ids) =>
      _guard(() => _search.findByIds(ids));

  @override
  Future<Either<Failure, List<Passage>>> lessonPassages(String lessonId,
          {required int maxChars}) =>
      _guard(() => _search.lessonPassages(lessonId, maxChars: maxChars));

  Future<Either<Failure, List<Passage>>> _guard(
      Future<List<Passage>> Function() run) async {
    try {
      return Right(await run());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
