import 'package:equatable/equatable.dart';

import 'answer_source.dart';

class TutorAnswer extends Equatable {
  const TutorAnswer({
    required this.text,
    this.source,
    this.fromBank = false,
    this.stopped = false,
  });

  final String text;
  final AnswerSource? source;

  /// True when the answer is stored in the pack's question bank.
  final bool fromBank;

  /// True when the student stopped generation and the text is partial.
  final bool stopped;

  @override
  List<Object?> get props => [text, source, fromBank, stopped];
}
