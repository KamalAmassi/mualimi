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

  /// Hero title before the grade ordinal (e.g. "... التاسع").
  static const String packTitlePrefix = 'رزمة الصف';

  /// Separator between the parts of the hero pack line.
  static const String packLineSeparator = ' · ';

  /// Word after the subject count in the hero pack line.
  static const String subjectsWord = 'مواد';

  /// Word before the version number in the hero pack line.
  static const String versionWord = 'الإصدار';

  /// Hero side text: the pack downloads once.
  static const String onceOnly = 'مرة واحدة فقط';

  /// Content step subtitle while it is not done.
  static const String contentStepHint = 'الدروس والشرح والأسئلة والحلول';

  /// Integrity step subtitle while it is not done.
  static const String integrityStepHint = 'للتأكد أن الرزمة سليمة';

  /// Checklist step: unpacking the pack on the device.
  static const String installStep = 'تجهيز الدروس';

  /// Install step subtitle.
  static const String installStepHint = 'فك الرزمة على جهازك';

  /// Bold lead of the resume reassurance banner.
  static const String resumeTipLead = 'انقطع الإنترنت؟ لا مشكلة.';

  /// Body of the resume reassurance banner.
  static const String resumeTipBody = 'التنزيل يكمل من نفس النقطة عند عودة الاتصال.';

  /// Note under the banner. From the splash tagline; replaces the design's later-download note.
  static const String worksOffline = 'تعمل بدون إنترنت';

  /// Hero subtitle of a paused download, before the saved percent.
  static const String pausedLabel = 'متوقف مؤقتاً';

  /// Words before the saved percent in the paused hero subtitle.
  static const String savedUpTo = 'محفوظ حتى';

  /// Banner title when the connection was lost.
  static const String connectionLostTitle = 'انقطع الاتصال بالإنترنت';

  /// Banner body when the connection was lost: it resumes on its own.
  static const String connectionLostBody = 'لا تقلق، ما نزل محفوظ. سيُستأنف التنزيل تلقائياً عند عودة الاتصال من نفس النقطة.';

  /// First sentence of [connectionLostBody]: what arrived is kept.
  static const String pausedSavedNote = 'لا تقلق، ما نزل محفوظ.';

  /// Content step subtitle while waiting for the network.
  static const String waitingForConnection = 'بانتظار الاتصال…';

  /// Paused-screen button that resumes the download.
  static const String resumeNow = 'استئناف الآن';
}
