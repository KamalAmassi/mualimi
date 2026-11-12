# معلّمي — مرجع التصميم للتنفيذ

هذا المجلد هو **المصدر الوحيد للتصميم**. كل شاشة ملف HTML مستقل يفتح في المتصفح، بقياس هاتف 390×844 (بعض الشاشات أطول لأنها تُمرَّر).

## المحتويات

```
design/
├── README.md              ← هذا الملف
├── screens/light/*.html + *.png   ← 33 شاشة وحالة · الوضع الفاتح
├── screens/dark/*.html  + *.png   ← نفس الشاشات · الوضع الداكن
└── theme/
    ├── tokens.json        ← كل الألوان للوضعين (المصدر)
    ├── app_colors.dart    ← → lib/core/constants/app_colors.dart
    └── app_theme.dart     ← → lib/core/theme/app_theme.dart
```

## طريقة العمل لكل شاشة (إلزامية)

1. **قبل البناء:** افتح صورة الشاشة `screens/light/<الاسم>.png` لترى الشكل النهائي، ثم اقرأ `screens/light/<الاسم>.html` لتأخذ القيم الدقيقة (المسافات، الخطوط، الألوان، الترتيب).
2. **ابنِ الشاشة** حسب القواعد أدناه.
3. **بعد البناء:** قارن نتيجتك بالصورة عنصراً عنصراً، وبصورة `screens/dark/<الاسم>.png` للوضع الداكن، وأصلح أي اختلاف قبل أن تنتهي.

الصور مرجع للشكل، وملف HTML مرجع للقيم. عند أي اختلاف بينهما، القيمة في HTML هي الصحيحة.
بعض الصور أطول من الشاشة لأن محتواها يُمرَّر، والمساحة الفارغة في أسفل صفحة الدرس هي مكان الزر العائم.

## قواعد التنفيذ (إلزامية)

1. **طابق التصميم بالضبط:** المسافات (padding/gap)، أنصاف الأقطار (radius)، أحجام الخط وأوزانه، وترتيب العناصر. القيم مكتوبة في `style` داخل كل ملف HTML: حوّلها كما هي (px → logical pixels).
2. **لا ألوان ثابتة:** كل لون في HTML موجود في `theme/tokens.json`. استخدم `context.colors.<name>` من `AppColors`، ولا تكتب `Color(0x…)` داخل أي واجهة. الاستثناء الوحيد: صفحة الكتاب في `ViewerPDF` (هي محتوى الكتاب نفسه).
3. **الوضعان:** نفّذ من ملفات `light/`، وتأكد أن الشاشة تطابق ملف `dark/` تلقائياً عبر `AppTheme.dark`، بدون كود خاص بالوضع الداكن داخل الواجهات.
4. **RTL والعربية:** `Directionality` RTL، والخط IBM Plex Sans Arabic (400/500/600/700). أيقونة الرجوع سهم يشير لليمين.
5. **الأيقونات:** في HTML هي SVG بخط 1.9. استخدم أقرب أيقونة من `lucide_icons` أو SVG نفسه عبر `flutter_svg`.
6. **المكوّنات المتكررة** (البطاقات، الشرائح، الأزرار، شريط التنقل، الـ Bottom Sheet، رسائل الحالة) تُبنى مرة واحدة في `core/widgets/` وتُعاد.
7. **النصوص بين أقواس مربعة** مثل `[حجم الرزمة]` قيم تأتي من البيانات (manifest أو الجهاز)، وليست نصاً ثابتاً.

## خريطة الشاشات → الكود

| الملف | الشاشة | Feature | ملاحظة |
|---|---|---|---|
| Splash | البداية | onboarding | تذهب للرئيسية مباشرة إن اكتمل الـ Onboarding |
| Welcome | الترحيب والاسم | onboarding | الخطوة 1/3 |
| Grade | اختيار الصف | onboarding | الخطوة 2/3 · التاسع فقط متاح في الـ MVP |
| Download | تنزيل الرزمة | content_manager | الخطوة 3/3 |
| DownloadPaused | التنزيل متوقف | content_manager | استئناف تلقائي (HTTP Range) |
| DownloadNoSpace | المساحة غير كافية | content_manager | |
| DownloadFailed | فشل فحص السلامة | content_manager | SHA-256 |
| PackUpdate | تحديث الرزمة | content_manager | Bottom Sheet فوق الرئيسية |
| Home | المواد (الرئيسية) | subjects | تبويب 1 |
| Subject | دروس المادة | subjects | الوحدات قابلة للطي |
| Lesson | صفحة الدرس | lesson | زر المعلّم عائم · بدون نت: بطاقة «الفيديو يحتاج إنترنت» |
| LessonSolutions | تبويب حلول الكتاب | lesson | |
| LessonMath | درس رياضيات | lesson | `tutorEnabled: false` ← زر المعلّم معطّل · المعادلات بـ flutter_math_fork |
| VideoRemoved | الفيديو محذوف | lesson | |
| KeyTerms | بطاقات المصطلحات | lesson | |
| Viewer | عارض: الشرح | lesson | |
| ViewerPDF | عارض: الكتاب PDF | lesson | pdfx |
| ViewerSolutions | عارض: الحلول | lesson | |
| Tutor | المحادثة | curriculum_tutor | تبويب 2 · streaming + زر إيقاف |
| TutorEmpty | محادثة جديدة | curriculum_tutor | |
| TutorSetup | قبل تنزيل الموديل | curriculum_tutor | model_download_card + تنبيه بيانات الجوال |
| TutorLoading | تحميل الموديل في الذاكرة | curriculum_tutor | |
| TutorMath | الرياضيات قريباً | curriculum_tutor | |
| TutorWeakDevice | وضع البحث | curriculum_tutor | رام غير كافٍ ← عرض المقاطع بدون توليد |
| LessonPicker | اختيار المادة والدرس | curriculum_tutor | lesson_picker_sheet |
| ReportSheet | الإبلاغ عن جواب | curriculum_tutor | Bottom Sheet |
| Saved | المحفوظات | curriculum_tutor | saved_answers_screen |
| SavedHistory | سجل الأسئلة | curriculum_tutor | |
| SavedEmpty | المحفوظات فارغة | curriculum_tutor | |
| Profile | حسابي | profile | تبويب 3 · فيه مفتاح المظهر |
| EditName | تعديل الاسم | profile | Bottom Sheet |
| ChangeGrade | تغيير الصف | profile | Bottom Sheet |
| DeleteModel | تأكيد الحذف | profile | Dialog |

## طلب جاهز لـ Claude Code

> اقرأ `design/README.md` والتزم بـ «طريقة العمل لكل شاشة». انسخ ملفي `design/theme/*.dart` إلى أماكنهما وفعّل `AppTheme.light/dark` في `GetMaterialApp`. ثم افتح `design/screens/light/<اسم الملف>.png` و`.html` ونفّذ الشاشة بالضبط حسب قواعد هذا الملف، داخل الـ feature المذكورة في الجدول، باستخدام GetX و Clean Architecture الموجودة. وفي النهاية قارن النتيجة بالصورتين (الفاتح والداكن) وأصلح أي اختلاف.

نفّذ شاشة أو اثنتين في كل طلب، بادئاً بالمكوّنات المشتركة ثم Splash → Welcome → Grade → Download → Home.
