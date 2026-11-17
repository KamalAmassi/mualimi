import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/key_term.dart';
import '../../domain/usecases/get_key_terms_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import '../widgets/key_terms_dimens.dart';

class KeyTermsController extends GetxController {
  KeyTermsController(this._getKeyTerms, this._getLesson);
  final GetKeyTermsUseCase _getKeyTerms;
  final GetLessonUseCase _getLesson;

  final terms = <KeyTerm>[].obs;
  final failure = Rxn<Failure>();
  final lessonTitle = RxnString();
  final loading = true.obs;
  final index = 0.obs;
  final showingDefinition = false.obs;
  final scrollController = ScrollController();

  String get lessonId => Get.parameters['lessonId'] ?? '';

  KeyTerm get current => terms[index.value];
  bool get hasPrevious => index.value > 0;
  bool get hasNext => index.value < terms.length - 1;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> load() async {
    loading.value = true;
    final lesson = await _getLesson(lessonId);
    lessonTitle.value = lesson.fold((_) => null, (l) => l.title);
    final result = await _getKeyTerms(lessonId);
    result.fold((f) {
      failure.value = f;
      terms.clear();
    }, (list) {
      failure.value = null;
      terms.assignAll(list);
    });
    index.value = 0;
    showingDefinition.value = false;
    loading.value = false;
  }

  void flip() => showingDefinition.toggle();

  void next() {
    if (hasNext) _select(index.value + 1);
  }

  void previous() {
    if (hasPrevious) _select(index.value - 1);
  }

  void showCard(int position) {
    if (position < 0 || position >= terms.length) return;
    _select(position);
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
          duration: KeyTermsDimens.flipDuration, curve: Curves.easeOut);
    }
  }

  void _select(int position) {
    index.value = position;
    showingDefinition.value = false;
  }
}
