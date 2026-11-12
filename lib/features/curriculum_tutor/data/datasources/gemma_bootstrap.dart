import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_embeddings/flutter_gemma_embeddings.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';

/// Registers the LiteRT-LM engine, embedding backend and tokenizers once.
/// This only registers providers; no model is loaded.
class GemmaBootstrap {
  Future<void>? _initialized;

  Future<void> ensureInitialized() => _initialized ??= FlutterGemma.initialize(
        inferenceEngines: [LiteRtLmEngine()],
        embeddingBackends: [LiteRtEmbeddingBackend()],
        embeddingTokenizers: [GemmaEmbeddingTokenizers()],
      );
}
