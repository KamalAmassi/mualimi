/// Thrown by data sources; repositories map them to [Failure]s.
class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseException extends AppException {
  const DatabaseException([super.message = 'database error']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'network error']);
}

class StorageException extends AppException {
  const StorageException([super.message = 'storage error']);
}

class IntegrityException extends AppException {
  const IntegrityException([super.message = 'checksum mismatch']);
}

class ManifestException extends AppException {
  const ManifestException([super.message = 'invalid manifest']);
}

class ModelException extends AppException {
  const ModelException([super.message = 'model error']);
}
