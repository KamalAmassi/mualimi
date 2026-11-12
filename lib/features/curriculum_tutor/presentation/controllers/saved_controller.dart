import 'package:get/get.dart';

import '../../domain/entities/question_history_item.dart';
import '../../domain/entities/saved_answer.dart';
import '../../domain/usecases/delete_saved_answer_usecase.dart';
import '../../domain/usecases/get_question_history_usecase.dart';
import '../../domain/usecases/get_saved_answers_usecase.dart';

/// Backs `/saved`: saved answers and the question history.
class SavedController extends GetxController {
  SavedController(this._getSaved, this._getHistory, this._delete);

  final GetSavedAnswersUseCase _getSaved;
  final GetQuestionHistoryUseCase _getHistory;
  final DeleteSavedAnswerUseCase _delete;

  final saved = <SavedAnswer>[].obs;
  final history = <QuestionHistoryItem>[].obs;
  final showHistory = false.obs;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    saved.assignAll(await _getSaved());
    history.assignAll(await _getHistory());
  }

  void selectTab({required bool history}) => showHistory.value = history;

  Future<void> remove(SavedAnswer answer) async {
    if (answer.id == null) return;
    await _delete(answer.id!);
    saved.remove(answer);
  }
}
