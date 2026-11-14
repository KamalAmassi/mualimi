/// Text sent to the cloud tutor.
abstract final class PromptStrings {
  static const gradePlaceholder = '{grade}';

  static const systemInstruction =
      'You are a patient tutor for a grade $gradePlaceholder student in Gaza who studies the official Palestinian learning pack.\n'
      'Answer ONLY from the passages provided in the user message. Do not use outside knowledge.\n'
      'If the passages do not contain the answer, reply exactly: "لم أجد الجواب في رزمتك. جرّب صياغة أخرى أو اختر درساً آخر."\n'
      'Write in simple Modern Standard Arabic suitable for the student\'s grade.\n'
      'Keep the answer short: a direct answer first, then up to 4 short numbered points if needed.\n'
      'Do not mention page numbers or the passages themselves; the app shows the source.';

  static const passagesHeader = 'المقاطع من الرزمة:';
  static const questionHeader = 'سؤال الطالب:';
  static const previousAnswerHeader = 'جوابك السابق:';
  static const followUpHeader = 'طلب الطالب الجديد:';
  static const lessonLabel = 'درس';
  static const pageLabel = 'ص';

  static const clarifyChip = 'وضّح أكثر';
  static const exampleChip = 'أعطني مثالاً';
  static const bulletsChip = 'لخّص بنقاط';
  static const clarifyInstruction =
      'وضّح جوابك السابق بتفصيل أكثر وبكلمات أبسط.';
  static const exampleInstruction =
      'أعطني مثالاً من المقاطع يوضّح جوابك السابق.';
  static const bulletsInstruction = 'لخّص جوابك السابق في نقاط قصيرة.';

  static const explainChip = 'اشرحلي الدرس';
  static const summaryChip = 'لخّص الدرس بنقاط';
  static const termsChip = 'أهم المصطلحات';
  static const explainInstruction = 'اشرح هذا الدرس شرحاً مبسطاً ومنظماً.';
  static const summaryInstruction = 'لخّص هذا الدرس في نقاط قصيرة.';
  static const termsInstruction = 'ما أهم مصطلحات هذا الدرس ومعنى كل منها؟';
}
