import 'package:equatable/equatable.dart';

import 'answer_source.dart';

/// One stored question with its answer from the pack's question bank.
class BankEntry extends Equatable {
  const BankEntry({
    required this.id,
    required this.questionNormalized,
    required this.answer,
    required this.source,
  });

  final int id;
  final String questionNormalized;
  final String answer;
  final AnswerSource source;

  @override
  List<Object?> get props => [id, questionNormalized, answer, source];
}
