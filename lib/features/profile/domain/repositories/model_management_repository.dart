abstract class ModelManagementRepository {
  /// Deletes the model file only; the student's data is untouched.
  /// False if the model is busy (loading / verifying) and nothing was deleted.
  Future<bool> deleteModel();
}
