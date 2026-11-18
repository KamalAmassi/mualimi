abstract class SubjectTutorRepository {
  /// False when the subject is missing or the pack cannot be read.
  Future<bool> isTutorEnabled(String subjectId);
}
