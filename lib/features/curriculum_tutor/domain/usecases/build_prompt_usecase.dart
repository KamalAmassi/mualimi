import '../../../../core/constants/prompt_strings.dart';
import '../entities/retrieved_chunk.dart';

class BuildPromptUseCase {
  const BuildPromptUseCase();

  String call(String question, List<RetrievedChunk> chunks) {
    final b = StringBuffer()
      ..writeln(PromptStrings.system)
      ..writeln()
      ..writeln(PromptStrings.passagesHeader);
    for (var i = 0; i < chunks.length; i++) {
      b.writeln('[${i + 1}] (${PromptStrings.pageLabel} ${chunks[i].page}) ${chunks[i].text}');
    }
    b
      ..writeln()
      ..writeln('${PromptStrings.questionHeader} $question')
      ..write(PromptStrings.answerHeader);
    return b.toString();
  }
}
