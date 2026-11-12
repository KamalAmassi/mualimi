import 'package:equatable/equatable.dart';

import 'answer_source.dart';
import 'retrieved_chunk.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.source,
    this.passages = const [],
    this.question,
  });

  final int id;
  final String text;
  final bool isUser;
  final AnswerSource? source;
  final List<RetrievedChunk> passages;

  /// For an answer: the question it answers (needed to save or report it).
  final String? question;

  ChatMessage copyWith({String? text, AnswerSource? source, List<RetrievedChunk>? passages}) =>
      ChatMessage(
        id: id,
        text: text ?? this.text,
        isUser: isUser,
        source: source ?? this.source,
        passages: passages ?? this.passages,
        question: question,
      );

  @override
  List<Object?> get props => [id, text, isUser, source, passages, question];
}
