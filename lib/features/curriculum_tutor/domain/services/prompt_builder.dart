import '../../../../core/constants/prompt_strings.dart';
import '../entities/llm_prompt.dart';
import '../entities/passage.dart';

/// Builds the system instruction and the single user message for the tutor.
class PromptBuilder {
  const PromptBuilder();

  /// [previousAnswer] and [followUpInstruction] are set only for follow-up
  /// requests, which reuse the passages of the original question.
  LlmPrompt build({
    required int? grade,
    required String question,
    required List<Passage> passages,
    String? previousAnswer,
    String? followUpInstruction,
  }) {
    final message = StringBuffer(PromptStrings.passagesHeader);
    for (var i = 0; i < passages.length; i++) {
      final p = passages[i];
      message
        ..write('\n[${i + 1}] (${PromptStrings.lessonLabel}: ${p.lessonTitle}')
        ..write(' · ${PromptStrings.pageLabel} ${p.printedPage})\n${p.text}');
    }
    message.write('\n\n${PromptStrings.questionHeader}\n$question');
    if (previousAnswer != null && followUpInstruction != null) {
      message
        ..write('\n\n${PromptStrings.previousAnswerHeader}\n$previousAnswer')
        ..write('\n\n${PromptStrings.followUpHeader}\n$followUpInstruction');
    }
    return LlmPrompt(
      systemInstruction: PromptStrings.systemInstruction
          .replaceAll(PromptStrings.gradePlaceholder, '${grade ?? ''}'),
      userMessage: message.toString(),
    );
  }
}
