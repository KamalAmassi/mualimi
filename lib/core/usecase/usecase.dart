import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

abstract class StreamUseCase<T, P> {
  Stream<T> call(P params);
}

class NoParams {
  const NoParams();
}
