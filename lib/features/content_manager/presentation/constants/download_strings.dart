// Strings used by the shared download-screen widgets.
// Extracted by script from design/screens/light/Download*.html — do not retype.
abstract final class DownloadStrings {
  /// Footer step label (e.g. "step 3 of 3").
  static const String stepLabel = 'الخطوة ٣ من ٣';

  /// Accessible label of the header back button.
  static const String back = 'رجوع';

  /// Arabic percent sign shown after the hero numeral.
  static const String percentSign = '٪';

  /// Header title of the pack download screens.
  static const String packTitle = 'تنزيل رزمة الصف';

  /// No-space status title.
  static const String noSpaceTitle = 'المساحة على جهازك غير كافية';

  /// No-space status body.
  static const String noSpaceBody = 'رزمة الصف تحتاج مساحة أكبر من المتاح حالياً. احذف بعض الصور أو التطبيقات ثم حاول مرة أخرى.';

  /// Space-compare label of the space the pack needs.
  static const String requiredLabel = 'المطلوب للرزمة';

  /// Space-compare label of the free space on the device.
  static const String availableLabel = 'المتاح على جهازك';

  /// No-space button that checks the free space again.
  static const String checkAgain = 'تحقق مرة أخرى';

  /// Integrity-failure status title.
  static const String integrityTitle = 'الملف وصل غير مكتمل';

  /// Integrity-failure status body.
  static const String integrityBody = 'فحص السلامة اكتشف أن الرزمة تالفة، غالباً بسبب انقطاع أثناء التنزيل. لن نفتح ملفاً تالفاً حفاظاً على دروسك.';

  /// Checklist step: the free-space check.
  static const String spaceCheckStep = 'فحص المساحة الفارغة';

  /// Free-space step subtitle once it passed.
  static const String spaceCheckDone = 'المساحة كافية';

  /// Checklist step: downloading the content.
  static const String contentStep = 'تنزيل المحتوى';

  /// Content step subtitle once it finished.
  static const String contentDone = 'اكتمل';

  /// Checklist step: the file integrity check.
  static const String integrityStep = 'فحص سلامة الملف';

  /// Integrity step subtitle when the check failed.
  static const String integrityMismatch = 'الملف لا يطابق النسخة الأصلية';

  /// Integrity-failure button that downloads the pack again.
  static const String redownload = 'إعادة التنزيل';

  /// Generic-failure status body. Not in the designs; wording approved by the team.
  static const String failedBody = 'تحقق من اتصالك بالإنترنت ثم حاول مرة أخرى. سيكمل التنزيل من حيث توقف.';
}
