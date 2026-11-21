import '../../../content_manager/presentation/constants/grade_ordinals.dart';

/// Student-facing copy of gap filling. Encouraging, never judging: no
/// scores, no failure words.
abstract final class GapFillingStrings {
  static const introTitle = 'خلّينا نعرف من وين نبدأ';
  static const introBody =
      'أسئلة قصيرة عن مهارات من الصفوف السابقة. ما في علامات ولا نجاح أو رسوب، الهدف نعرف شو بنراجع سوا.';
  static const introSubjects = 'المواد اللي رح نسأل عنها';
  static const start = 'ابدأ';
  static const later = 'لاحقاً';

  static const next = 'التالي';
  static const dontKnow = 'ما بعرف';
  static const dividerLead = 'الدور الآن على مادة';
  static const dividerContinue = 'يلا نكمل';

  static const resultTitle = 'شكراً إلك، صرنا نعرف من وين نبدأ';
  static const strongSkills = 'أحسنت! في مهارات قوية عندك';
  static const pathTitle = 'مسارك للمراجعة';
  static const nothingToReview = 'ما في مهارات بحاجة مراجعة هون، كمّل هيك';
  static const reviewNow = 'راجع الآن';
  static const startStudy = 'ابدأ الدراسة';

  static const reviewIntro = 'اقرأ الشرح على مهلك، وبعدها جرّب أسئلة قصيرة.';
  static const startQuestions = 'جاهز للأسئلة';
  static const correct = 'أحسنت';
  static const seeResult = 'كمّل';
  static const reviewStronger = 'ممتاز! هالمهارة صارت أقوى';
  static const reviewTryLater =
      'ولا يهمك، المراجعة بتفرق. جرّب مرة ثانية لاحقاً';
  static const reviewAgain = 'راجع مرة ثانية';
  static const backToLesson = 'ارجع للدرس';
  static const back = 'رجوع';

  static const pathInviteTitle = 'اعرف مستواك وابدأ مسارك';
  static const pathInviteAction = 'اعرف مستواك';
  static const pathCardTitle = 'مسارك';
  static const pathAllGood = 'ممتاز! ما في مهارات بحاجة مراجعة حالياً';
  static const prerequisitesTitle = 'قبل ما تبدأ، راجع:';

  static const loadFailedTitle = 'ما قدرنا نفتح هالصفحة';
  static const loadFailedMessage = 'جرّب مرة ثانية بعد شوي.';

  static String minutes(int count) => count <= 1
      ? 'حوالي دقيقة'
      : count == 2
          ? 'حوالي دقيقتين'
          : count <= 10
              ? 'حوالي $count دقائق'
              : 'حوالي $count دقيقة';

  static String questionOf(int current, int total) => 'سؤال $current من $total';

  static String fromGrade(int grade) => 'من الصف ${GradeOrdinals.of(grade)}';
}
