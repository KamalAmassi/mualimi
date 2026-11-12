import 'package:flutter_gemma/flutter_gemma.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/tutor_engine_service.dart';
import 'gemma_runtime.dart';
import 'llm_data_source.dart';

class GemmaLlmDataSource implements LlmDataSource {
  GemmaLlmDataSource(this._runtime, this._engine);

  final GemmaRuntime _runtime;
  final TutorEngineService _engine;
  InferenceModelSession? _session;

  @override
  Stream<String> generate(String prompt, {required int maxOutputTokens}) async* {
    // A question asked while the model is loading waits here, then is sent.
    if (!await _engine.whenReady()) {
      throw const ModelException('model is not ready');
    }
    final session = await _runtime.model.createSession(
      topK: Limits.generationTopK,
      temperature: Limits.generationTemperature,
      maxOutputTokens: maxOutputTokens,
    );
    _session = session;
    try {
      await session.addQueryChunk(Message(text: prompt, isUser: true));
      yield* session.getResponseAsync();
    } finally {
      _session = null;
      await session.close();
    }
  }

  @override
  Future<void> stop() async => _session?.stopGeneration();
}
