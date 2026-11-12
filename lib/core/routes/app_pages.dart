import 'package:get/get.dart';

import '../../features/content_manager/presentation/bindings/download_binding.dart';
import '../../features/content_manager/presentation/pages/download_page.dart';
import '../../features/lesson/presentation/bindings/lesson_binding.dart';
import '../../features/lesson/presentation/pages/key_terms_page.dart';
import '../../features/lesson/presentation/pages/lesson_page.dart';
import '../../features/lesson/presentation/pages/viewer_page.dart';
import '../../features/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../features/onboarding/presentation/pages/grade_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/shell/presentation/bindings/shell_binding.dart';
import '../../features/shell/presentation/pages/main_shell_page.dart';
import '../../features/subjects/presentation/bindings/subjects_binding.dart';
import '../../features/subjects/presentation/pages/subject_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: SplashPage.new, binding: OnboardingBinding()),
    GetPage(name: AppRoutes.welcome, page: WelcomePage.new, binding: OnboardingBinding()),
    GetPage(name: AppRoutes.grade, page: GradePage.new, binding: OnboardingBinding()),
    GetPage(name: AppRoutes.download, page: DownloadPage.new, binding: DownloadBinding()),
    GetPage(name: AppRoutes.shell, page: MainShellPage.new, binding: ShellBinding()),
    GetPage(name: AppRoutes.subject, page: SubjectPage.new, binding: SubjectsBinding()),
    GetPage(name: AppRoutes.lesson, page: LessonPage.new, binding: LessonBinding()),
    GetPage(name: AppRoutes.viewer, page: ViewerPage.new, binding: LessonBinding()),
    GetPage(name: AppRoutes.keyTerms, page: KeyTermsPage.new, binding: LessonBinding()),
  ];
}
