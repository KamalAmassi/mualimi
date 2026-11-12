import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import 'answer_source.dart';
import 'retrieved_chunk.dart';

/// What the tutor pipeline emits for one question.
sealed class TutorEvent extends Equatable {
  const TutorEvent();

  @override
  List<Object?> get props => [];
}

class TutorToken extends TutorEvent {
  const TutorToken(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

/// Search-only devices (and prebuilt-free fallbacks) show passages, no generation.
class TutorPassages extends TutorEvent {
  const TutorPassages(this.chunks);
  final List<RetrievedChunk> chunks;

  @override
  List<Object?> get props => [chunks];
}

class TutorOutOfScope extends TutorEvent {
  const TutorOutOfScope();
}

class TutorSubjectUnsupported extends TutorEvent {
  const TutorSubjectUnsupported();
}

class TutorDone extends TutorEvent {
  const TutorDone(this.source);
  final AnswerSource? source;

  @override
  List<Object?> get props => [source];
}

class TutorError extends TutorEvent {
  const TutorError(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
