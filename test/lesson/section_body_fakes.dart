import 'package:mualimi/features/lesson/domain/repositories/pack_image_repository.dart';
import 'package:mualimi/features/lesson/domain/usecases/get_pack_image_path_usecase.dart';
import 'package:mualimi/features/lesson/domain/usecases/parse_section_body_usecase.dart';
import 'package:mualimi/features/lesson/presentation/controllers/section_body_controller.dart';

/// Resolves every reference to [path], or to nothing when [path] is null.
class FakePackImageRepository implements PackImageRepository {
  FakePackImageRepository([this.path]);

  final String? path;
  final requested = <String>[];

  @override
  String? imagePathOf(String relativePath) {
    requested.add(relativePath);
    return path;
  }
}

SectionBodyController sectionBodyController([PackImageRepository? images]) => SectionBodyController(
      const ParseSectionBodyUseCase(),
      GetPackImagePathUseCase(images ?? FakePackImageRepository()),
    );
