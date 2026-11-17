import '../entities/student_summary.dart';

abstract class StudentRepository {
  /// Emits the current student first, then every change.
  Stream<StudentSummary> watch();
}
