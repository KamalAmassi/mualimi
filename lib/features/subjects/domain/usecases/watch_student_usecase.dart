import '../../../../core/usecase/usecase.dart';
import '../entities/student_summary.dart';
import '../repositories/student_repository.dart';

class WatchStudentUseCase implements StreamUseCase<StudentSummary, NoParams> {
  WatchStudentUseCase(this._repository);
  final StudentRepository _repository;

  @override
  Stream<StudentSummary> call(NoParams params) => _repository.watch();
}
