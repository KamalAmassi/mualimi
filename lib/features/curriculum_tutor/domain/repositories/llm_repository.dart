import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/llm_prompt.dart';

abstract class LlmRepository {
  /// Streams answer text. A failure ends the stream with a single Left.
  /// After [stop] the stream completes normally with the text so far.
  Stream<Either<Failure, String>> streamAnswer(LlmPrompt prompt);

  /// The whole answer in one request (used for queued questions).
  Future<Either<Failure, String>> answer(LlmPrompt prompt);

  /// True when the last streamed answer ended because [stop] was called.
  bool get wasStopped;

  Future<void> stop();
}
