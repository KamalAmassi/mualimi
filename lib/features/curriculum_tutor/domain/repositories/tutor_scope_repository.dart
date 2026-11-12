abstract class TutorScopeRepository {
  /// False when the subject (or the given lesson) is not tutor-enabled, e.g. math.
  Future<bool> isTutorEnabled(String subjectId, {String? lessonId});
}
