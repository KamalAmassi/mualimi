import 'package:flutter_gemma/flutter_gemma.dart';

import '../../../../core/constants/limits.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/model_runtime.dart';
import 'gemma_bootstrap.dart';

/// Loads the Gemma `.litertlm` file into RAM through flutter_gemma.
/// [TutorEngineService] calls [load] only when the student reaches the tutor.
class GemmaRuntime implements ModelRuntime {
  GemmaRuntime(this._bootstrap);

  final GemmaBootstrap _bootstrap;
  InferenceModel? _model;

  /// Shared with the embedding data source so providers register once.
  GemmaBootstrap get bootstrap => _bootstrap;

  InferenceModel get model {
    final m = _model;
    if (m == null) throw const ModelException('model is not loaded');
    return m;
  }

  @override
  Future<void> load(String modelPath) async {
    await _bootstrap.ensureInitialized();
    // `fileType` (not the file name) selects the engine.
    await FlutterGemma.installModel(
      modelType: ModelType.gemma4,
      fileType: ModelFileType.litertlm,
    ).fromFile(modelPath).install();
    // `maxTokens` is the context window; the reply cap is set per session.
    _model = await FlutterGemma.getActiveModel(maxTokens: Limits.contextTokens);
  }

  @override
  Future<void> unload() async {
    await _model?.close();
    _model = null;
  }
}
