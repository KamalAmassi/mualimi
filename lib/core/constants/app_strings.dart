/// Static UI strings. Data-driven values (names, sizes) never live here.
abstract final class AppStrings {
  static const appName = 'معلّمي';

  static const splash = 'البداية';
  static const welcome = 'الترحيب';
  static const grade = 'اختيار الصف';
  static const download = 'تنزيل الرزمة';
  static const subjects = 'المواد';
  static const smartTutor = 'المعلّم الذكي';
  static const profile = 'حسابي';
  static const subject = 'دروس المادة';
  static const lesson = 'الدرس';
  static const keyTerms = 'المصطلحات';
  static const viewer = 'العارض';
  static const saved = 'المحفوظات';

  static const next = 'التالي';
  static const retry = 'إعادة المحاولة';
  static const cancel = 'إلغاء';
  static const confirm = 'تأكيد';
  static const save = 'حفظ';
  static const delete = 'حذف';
  static const pause = 'إيقاف مؤقت';
  static const resume = 'استئناف';

  static const waitForWifi = 'انتظار شبكة Wi‑Fi';
  static const continueOnMobile = 'المتابعة على بيانات الجوال';
  static const askTutor = 'اسأل المعلّم';
  static const importFromFile = 'استيراد من ملف';

  // Downloads
  static const downloadPaused = 'التنزيل متوقف';
  static const downloadNoSpace = 'المساحة غير كافية';
  static const downloadFailed = 'فشل التنزيل';
  static const startDownload = 'ابدأ التنزيل';
  static const waitingForWifi = 'بانتظار شبكة Wi‑Fi';
  static const mobileDataTitle = 'أنت على بيانات الجوال';
  static const verifying = 'جارٍ التحقق من الملف';
  static const assembling = 'جارٍ تجهيز الملف';
  static const downloadDone = 'اكتمل التنزيل';
  static const packUpdate = 'تحديث الرزمة';
  static const updateNow = 'حدّث الآن';
  static const later = 'لاحقاً';

  // Onboarding
  static const studentNameHint = 'اكتب اسمك';
  static const studentNameInvalid = 'الاسم مطلوب';
  static const gradePrefix = 'الصف';

  // Lesson
  static const videoNeedsInternet = 'الفيديو يحتاج إنترنت';
  static const videoMissing = 'لا يوجد فيديو لهذا الدرس';

  // Profile
  static const editName = 'تعديل الاسم';
  static const changeGrade = 'تغيير الصف';
  static const toggleTheme = 'تبديل المظهر';

  // Tutor
  static const send = 'إرسال';
  static const tutorOnlineSubtitle = 'متصل · الأجوبة من رزمتك';
  static const tutorOfflineSubtitle = 'بدون إنترنت · بحث في رزمتك';
  static const subjectLabel = 'المادة:';
  static const lessonLabel = 'الدرس:';
  static const pickLessonOptional = '+ اختر درساً (اختياري)';
  static const askAboutAnyLessonIn = 'اسألني عن أي درس في';
  static const emptySubtitle =
      'أبحث في كتابك أولاً ثم أشرح، وأذكر لك الدرس ورقم الصفحة.';
  static const tryExample = 'جرّب مثلاً';
  static const exampleExplainLesson = 'اشرحلي درس {name}';
  static const exampleSummarizeLesson = 'لخّص درس {name} بنقاط';
  static const exampleTermsLesson = 'ما أهم مصطلحات درس {name}؟';
  static const exampleConcepts = 'ما أهم مفاهيم {name}؟';
  static const exampleStart = 'من أين أبدأ في {name}؟';
  static const exampleExplainSubject = 'اشرحلي أحد دروس {name}';
  static const askHint = 'اسأل عن الدرس أو اطلب شرح جزئية…';
  static const today = 'اليوم';
  static const yesterday = 'أمس';
  static const daysAgoPrefix = 'قبل';
  static const days = 'أيام';
  static const reportAnswer = 'الإبلاغ عن جواب خاطئ';
  static const stopGeneration = 'إيقاف التوليد';
  static const writingNow = 'يكتب الآن…';
  static const fromPack = 'من رزمتك';
  static const answerStopped = 'أوقفت التوليد قبل أن يكتمل الجواب';
  static const answerSaved = 'تم الحفظ';
  static const sourceLabel = 'المصدر';
  static const outOfScopeTitle = 'هذا السؤال غير موجود في رزمة المادة';
  static const outOfScopeBody =
      'أجيب فقط مما في كتابك حتى لا أعطيك معلومة غلط. جرّب صياغة أخرى أو اختر درساً آخر.';
  static const pendingBadge = 'بانتظار الإنترنت';
  static const deletePendingQuestion = 'حذف السؤال';
  static const offlineTitle = 'لا يوجد اتصال بالإنترنت';
  static const offlineExplanation =
      'هذه أقرب الفقرات من كتابك، وسأجيب عن سؤالك عندما يعود الاتصال.';
  static const needsInternetTitle = 'هذا الطلب يحتاج إلى إنترنت';
  static const needsInternetBody = 'جرّبه عندما يعود الاتصال.';
  static const notConfiguredTitle = 'المعلّم عبر الإنترنت غير مفعّل';
  static const notConfiguredExplanation = 'هذه أقرب الفقرات من كتابك لسؤالك.';
  static const dailyLimitTitle = 'وصلت إلى حد الأسئلة اليومي';
  static const dailyLimitExplanation =
      'هذه أقرب الفقرات من كتابك، ويمكنك السؤال من جديد غداً.';
  static const nearestPassages = 'أقرب الفقرات من الكتاب';
  static const openInPack = 'افتح في الكتاب';
  static const answerFailed = 'تعذّر إنشاء الجواب. حاول مرة أخرى.';
  static const mathSoonTitle = 'المعلّم الذكي للرياضيات قريباً';
  static const mathSoonBody =
      'نعمل على دعم المعادلات والرسوم. حالياً كل دروس الرياضيات متاحة بالفيديو والشرح المكتوب والحلول.';
  static const openSubjectLessons = 'افتح دروس';
  static const chooseOtherSubject = 'اختر مادة أخرى';
  static const comingSoon = 'قريباً';
  static const mathComposerHint = 'المعلّم يتجهّز… تقدر تدرس الدروس الآن';

  // Lesson picker
  static const chooseSubjectAndLesson = 'اختر المادة والدرس';
  static const wholeSubject = 'كل المادة';
  static const done = 'تم';
  static const close = 'إغلاق';
  static const pagesPrefix = 'ص';

  // Report
  static const reportIntro =
      'بلاغك يساعدنا نحسّن دقة المعلّم. ما المشكلة في الجواب؟';
  static const reportReasonWrong = 'المعلومة غير صحيحة';
  static const reportReasonMismatch = 'لا يطابق ما في الكتاب';
  static const reportReasonUnclear = 'الشرح غير مفهوم';
  static const reportReasonSource = 'المصدر أو رقم الصفحة خطأ';
  static const reportDetails = 'تفاصيل (اختياري)';
  static const reportNoteHint = 'اكتب ما لاحظته…';
  static const reportStoredNote = 'يُحفظ على جهازك ويُرسل عند توفر الإنترنت';
  static const sendReport = 'إرسال البلاغ';

  // Saved
  static const savedSubtitle = 'تُعرض فوراً بدون توليد';
  static const savedTab = 'الأجوبة المحفوظة';
  static const questionHistory = 'سجل الأسئلة';
  static const allSubjects = 'الكل';
  static const searchHistoryHint = 'ابحث في أسئلتك…';
  static const savedEmptyTitle = 'لا توجد أجوبة محفوظة بعد';
  static const savedEmptyBody =
      'اضغط «حفظ» تحت أي جواب من المعلّم ليظهر هنا، ويفتح لاحقاً بدون إنترنت.';
  static const historyEmptyTitle = 'لا توجد أسئلة بعد';

  // Notifications
  static const answersChannelName = 'أجوبة المعلّم';
  static const answerReadyPrefix = 'وصل جواب سؤالك:';
}
