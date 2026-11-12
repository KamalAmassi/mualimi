import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'database error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'network error']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'storage error']);
}

class NotEnoughSpaceFailure extends Failure {
  const NotEnoughSpaceFailure({required this.requiredBytes, required this.freeBytes})
      : super('not enough space');
  final int requiredBytes;
  final int freeBytes;

  @override
  List<Object?> get props => [message, requiredBytes, freeBytes];
}

class IntegrityFailure extends Failure {
  const IntegrityFailure([super.message = 'checksum mismatch']);
}

class ManifestFailure extends Failure {
  const ManifestFailure([super.message = 'invalid manifest']);
}

class ModelFailure extends Failure {
  const ModelFailure([super.message = 'model error']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'not found']);
}
