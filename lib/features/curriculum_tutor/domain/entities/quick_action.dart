import '../../../../core/constants/prompt_strings.dart';

/// One-tap lesson actions. `kind` matches `prebuilt_answers.kind`.
enum QuickAction {
  explain('explain', PromptStrings.explainQuestion),
  summary('summary', PromptStrings.summaryQuestion),
  terms('terms', PromptStrings.termsQuestion);

  const QuickAction(this.kind, this.question);
  final String kind;
  final String question;
}
