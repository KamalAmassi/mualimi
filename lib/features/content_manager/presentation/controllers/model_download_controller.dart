import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../../../core/services/tutor_engine_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/download_phase.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/entities/model_source_kind.dart';
import '../../domain/usecases/download_params.dart';
import '../../domain/usecases/get_manifest_usecase.dart';
import 'download_controller_base.dart';

/// Downloads (or imports) the tutor model and drives [TutorEngineService]
/// through its download states.
class ModelDownloadController extends DownloadControllerBase {
  ModelDownloadController({
    required super.download,
    required super.pause,
    required super.resume,
    required super.cancel,
    required super.connectivity,
    required GetManifestUseCase getManifest,
    required TutorEngineService engine,
  })  : _getManifest = getManifest,
        _engine = engine;

  final GetManifestUseCase _getManifest;
  final TutorEngineService _engine;
  String? _importPath;

  Rx<TutorEngineState> get engineState => _engine.state;

  /// TODO(file-picker): no file picker is in the fixed package list, so the UI
  /// has no way to obtain [path] yet. Wire one in when a picker is chosen.
  Future<void> importFromFile(String path) {
    _importPath = path;
    return startOffline();
  }

  @override
  Future<void> start() {
    _importPath = null;
    return super.start();
  }

  @override
  Future<DownloadParams?> buildParams() async {
    final engineState = _engine.state.value;
    if (engineState is SearchOnly || engineState is Unsupported) {
      failWith(const ModelFailure('device cannot run the model'));
      return null;
    }
    final result = await _getManifest(const NoParams());
    return result.fold(
      (f) {
        failWith(f);
        return null;
      },
      (manifest) {
        final model = manifest.model;
        if (model == null) {
          failWith(const NotFoundFailure('manifest has no model'));
          return null;
        }
        final path = _importPath;
        // An imported file replaces only the LLM; search embeddings come later.
        return path == null
            ? DownloadParams.model(model, embedding: manifest.embedding)
            : DownloadParams.model(model, source: ModelSourceKind.localFile, localPath: path);
      },
    );
  }

  @override
  void onProgress(DownloadProgress p) {
    switch (p.phase) {
      case DownloadPhase.downloading:
        if (_engine.state.value is Downloading) {
          _engine.updateProgress(p.fraction, p.bytesDone);
        } else {
          _engine.transitionTo(Downloading(progress: p.fraction, bytes: p.bytesDone));
        }
      case DownloadPhase.paused:
        _engine.transitionTo(const Paused());
      case DownloadPhase.verifying:
        _engine.transitionTo(const Verifying());
      case DownloadPhase.assembling:
        _engine.transitionTo(const Assembling());
      case DownloadPhase.completed:
        _engine.transitionTo(const Downloaded());
      case DownloadPhase.canceled:
        _engine.transitionTo(const NotDownloaded());
      case DownloadPhase.failed:
        _engine.transitionTo(Failed(p.failure?.message ?? 'download failed'));
    }
  }

  @override
  Future<void> onCompleted() async {}
}
