import '../../../../core/constants/prompt_strings.dart';

/// Chips under an answer. Each one asks the tutor to rework its last answer.
enum FollowUp {
  clarify(PromptStrings.clarifyChip, PromptStrings.clarifyInstruction),
  example(PromptStrings.exampleChip, PromptStrings.exampleInstruction),
  bullets(PromptStrings.bulletsChip, PromptStrings.bulletsInstruction);

  const FollowUp(this.label, this.instruction);
  final String label;
  final String instruction;
}
