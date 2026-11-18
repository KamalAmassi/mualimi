/// Profile copy taken from design/screens/light/Profile.html, except the
/// two larger font-size labels, which the design does not show.
abstract final class ProfileStrings {
  static const noAccount = 'بدون حساب، كل شيء على جهازك';
  static const separator = ' · ';
  static const storageTitle = 'المساحة المستخدمة';
  static const packSegment = 'رزمة الصف';
  static const pdfSegment = 'ملفات PDF';
  static const appearance = 'المظهر';
  static const themeLight = 'فاتح';
  static const themeDark = 'داكن';
  static const themeSystem = 'حسب الجهاز';
  static const study = 'الدراسة';
  static const grade = 'الصف';
  static const change = 'تغيير';
  static const fontSize = 'حجم الخط في الشرح';
  static const fontMedium = 'متوسط';
  static const downloads = 'التنزيلات';
  static const versionWord = 'الإصدار';
  static const upToDate = 'محدّثة';
  static const checkUpdate = 'تحقق من تحديث';
  static const aboutSection = 'عن التطبيق';
  static const about = 'عن معلّمي';
  static const aboutSubtitle = 'المحتوى من المنهاج الفلسطيني مع ذكر المصدر';
  static const editName = 'تعديل الاسم';
  static const fontLarge = 'كبير';
  static const fontExtraLarge = 'كبير جداً';

  static String packTitle(String gradeOrdinal) => '$packSegment $gradeOrdinal';
  static String version(int version) => '$versionWord $version';
}
