abstract class OnboardingRepository {
  bool get isOnboardingDone;
  bool get hasGrade;
  Future<void> saveStudentName(String name);
  Future<void> saveGrade(int grade);
}
