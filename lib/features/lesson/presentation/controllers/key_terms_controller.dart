import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/key_term.dart';
import '../../domain/usecases/get_key_terms_usecase.dart';

class KeyTermsController extends GetxController {
  KeyTermsController(this._getKeyTerms);
  final GetKeyTermsUseCase _getKeyTerms;

  final terms = <KeyTerm>[].obs;
  final failure = Rxn<Failure>();

  String get lessonId => Get.parameters['lessonId'] ?? '';

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    final result = await _getKeyTerms(lessonId);
    result.fold((f) => failure.value = f, (list) {
      failure.value = null;
      terms.assignAll(list);
    });
  }
}
