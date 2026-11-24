import 'package:get/get.dart';

import '../../domain/entities/section_block.dart';
import '../../domain/usecases/get_pack_image_path_usecase.dart';
import '../../domain/usecases/parse_section_body_usecase.dart';

/// Turns a section body into blocks for the viewer's explanation tab.
class SectionBodyController extends GetxController {
  SectionBodyController(this._parseBody, this._getImagePath);

  final ParseSectionBodyUseCase _parseBody;
  final GetPackImagePathUseCase _getImagePath;

  String? _lastBody;
  List<SectionBlock> _lastBlocks = const [];

  /// Parses [body] once; a rebuild for the same body (font size, theme)
  /// reuses the blocks.
  List<SectionBlock> blocksOf(String body) {
    if (body != _lastBody) {
      _lastBlocks = _parseBody(body);
      _lastBody = body;
    }
    return _lastBlocks;
  }

  String? imagePathOf(String relativePath) => _getImagePath(relativePath);
}
