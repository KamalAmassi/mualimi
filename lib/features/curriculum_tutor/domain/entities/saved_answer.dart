import 'package:equatable/equatable.dart';

import 'answer_source.dart';

class SavedAnswer extends Equatable {
  const SavedAnswer({
    this.id,
    required this.question,
    required this.answer,
    this.source,
    this.fromBank = false,
    this.createdAt,
  });

  final int? id;
  final String question;
  final String answer;
  final AnswerSource? source;
  final bool fromBank;
  final DateTime? createdAt;

  @override
  List<Object?> get props =>
      [id, question, answer, source, fromBank, createdAt];
}
