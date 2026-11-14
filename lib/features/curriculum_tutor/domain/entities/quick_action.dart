import '../../../../core/constants/prompt_strings.dart';

/// One-tap lesson actions. `kind` matches `prebuilt_answers.kind`.
enum QuickAction {
  explain(
      'explain', PromptStrings.explainChip, PromptStrings.explainInstruction),
  summary(
      'summary', PromptStrings.summaryChip, PromptStrings.summaryInstruction),
  terms('terms', PromptStrings.termsChip, PromptStrings.termsInstruction);

  const QuickAction(this.kind, this.label, this.instruction);
  final String kind;
  final String label;
  final String instruction;
}
