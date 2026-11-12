import 'package:flutter_gemma/flutter_gemma.dart';

import '../../../../core/constants/app_files.dart';
import '../../../../core/services/app_paths_service.dart';
import '../../../../core/services/settings_service.dart';
import 'embedding_data_source.dart';
import 'gemma_bootstrap.dart';

class GemmaEmbeddingDataSource implements EmbeddingDataSource {
  GemmaEmbeddingDataSource(this._bootstrap, this._paths, this._settings);

  final GemmaBootstrap _bootstrap;
  final AppPathsService _paths;
  final SettingsService _settings;
  EmbeddingModel? _embedder;

  // TODO(manifest): the embedder needs a tokenizer file as well as the model,
  // but the manifest's `embedding` entry describes only one file. Until the
  // manifest ships the tokenizer (as a second artifact or bundled in the
  // pack), a missing tokenizer makes this return null and search is
  // keyword-only.
  @override
  Future<List<double>?> embedQuery(String text) async {
    final embedder = await _load();
    if (embedder == null) return null;
    // Default task type is retrievalQuery, matching how chunks were indexed
    // (retrievalDocument) in the pack.
    return embedder.generateEmbedding(text);
  }

  Future<EmbeddingModel?> _load() async {
    if (_embedder != null) return _embedder;
    final name = _settings.installedEmbeddingFile.value;
    if (name == null) return null;
    final model = _paths.modelFile(name);
    final tokenizer = _paths.modelFile(AppFiles.embeddingTokenizerFile);
    if (!model.existsSync() || !tokenizer.existsSync()) return null;

    await _bootstrap.ensureInitialized();
    await FlutterGemma.installEmbedder()
        .modelFromFile(model.path)
        .tokenizerFromFile(tokenizer.path)
        .install();
    return _embedder = await FlutterGemma.getActiveEmbedder();
  }
}
