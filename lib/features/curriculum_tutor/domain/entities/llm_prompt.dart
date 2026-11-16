import 'package:equatable/equatable.dart';

class LlmPrompt extends Equatable {
  const LlmPrompt({required this.systemInstruction, required this.userMessage});

  final String systemInstruction;
  final String userMessage;

  @override
  List<Object?> get props => [systemInstruction, userMessage];
}
