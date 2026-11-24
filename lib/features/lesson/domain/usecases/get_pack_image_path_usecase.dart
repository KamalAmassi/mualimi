import '../repositories/pack_image_repository.dart';

class GetPackImagePathUseCase {
  GetPackImagePathUseCase(this._repository);
  final PackImageRepository _repository;

  String? call(String relativePath) => _repository.imagePathOf(relativePath);
}
