abstract class OnboardingRepository {
  bool get isOnboardingDone;
  Future<bool> isPackInstalled();
  Future<void> saveStudentName(String name);
  Future<void> saveGrade(int grade);
}
