/// Text sent to the model. Kept short: the model is small and runs on-device.
abstract final class PromptStrings {
  static const system =
      'أنت معلّم يساعد طلاب المنهاج الفلسطيني. أجب بالعربية وباختصار، '
      'اعتماداً على المقاطع التالية فقط. إن لم تجد الجواب فيها فقل إنك لا تعرف.';
  static const passagesHeader = 'المقاطع:';
  static const questionHeader = 'السؤال:';
  static const answerHeader = 'الجواب:';
  static const pageLabel = 'ص';

  static const explainQuestion = 'اشرح هذا الدرس بالتفصيل.';
  static const summaryQuestion = 'لخّص هذا الدرس في نقاط.';
  static const termsQuestion = 'ما أهم مصطلحات هذا الدرس ومعانيها؟';
}
