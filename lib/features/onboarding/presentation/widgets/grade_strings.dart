import '../../../../core/constants/app_strings.dart';
import '../../../content_manager/presentation/constants/grade_ordinals.dart';

/// Grade-only copy, taken from design/screens/light/Grade.html. The title and
/// the button label are split around the student's name and the grade.
abstract final class GradeStrings {
  static const titlePrefix = 'في أي صف أنت';
  static const vocative = 'يا';
  static const questionMark = '؟';
  static const subtitle = 'سننزّل محتوى صفك فقط، لتوفير الإنترنت والمساحة.';
  static const downloadPrefix = 'تنزيل رزمة';
  static const step = 'الخطوة ٢ من ٣';

  static String title(String name) =>
      name.isEmpty ? '$titlePrefix$questionMark' : '$titlePrefix $vocative $name$questionMark';

  static String downloadLabel(int grade) =>
      '$downloadPrefix ${AppStrings.gradePrefix} ${GradeOrdinals.of(grade)}';
}
