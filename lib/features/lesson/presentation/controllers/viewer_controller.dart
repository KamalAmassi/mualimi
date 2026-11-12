import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/book_solution.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/usecases/get_book_solutions_usecase.dart';
import '../../domain/usecases/get_lesson_usecase.dart';
import 'viewer_tab.dart';

/// Backs `/viewer/:lessonId?tab=` (explanation / book PDF / solutions).
class ViewerController extends GetxController {
  ViewerController(this._getLesson, this._getSolutions);

  final GetLessonUseCase _getLesson;
  final GetBookSolutionsUseCase _getSolutions;

  final tab = ViewerTab.explanation.obs;
  final lesson = Rxn<Lesson>();
  final solutions = <BookSolution>[].obs;
  final failure = Rxn<Failure>();

  String get lessonId => Get.parameters['lessonId'] ?? '';

  @override
  void onInit() {
    super.onInit();
    tab.value = ViewerTab.parse(Get.parameters['tab']);
  }

  @override
  void onReady() {
    super.onReady();
    load();
  }

  void select(ViewerTab value) => tab.value = value;

  Future<void> load() async {
    final lessonResult = await _getLesson(lessonId);
    lessonResult.fold((f) => failure.value = f, (l) => lesson.value = l);
    final solutionsResult = await _getSolutions(lessonId);
    solutionsResult.fold((f) => failure.value = f, solutions.assignAll);
  }
}
