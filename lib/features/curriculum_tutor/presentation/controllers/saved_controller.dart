import 'package:get/get.dart';

import '../../../../core/utils/arabic_normalizer.dart';
import '../../domain/entities/question_history_item.dart';
import '../../domain/entities/saved_answer.dart';
import '../../domain/usecases/delete_saved_answer_usecase.dart';
import '../../domain/usecases/get_question_history_usecase.dart';
import '../../domain/usecases/get_saved_answers_usecase.dart';
import '../formatting/day_label.dart';
import 'tutor_controller.dart';

class SubjectFilter {
  const SubjectFilter(this.id, this.name);
  final String id;
  final String name;
}

class HistoryGroup {
  const HistoryGroup(this.label, this.items);
  final String label;
  final List<QuestionHistoryItem> items;
}

/// Backs `/saved`: saved answers and the question history, both read from the
/// local database.
class SavedController extends GetxController {
  SavedController(this._getSaved, this._getHistory, this._delete, this._tutor);

  final GetSavedAnswersUseCase _getSaved;
  final GetQuestionHistoryUseCase _getHistory;
  final DeleteSavedAnswerUseCase _delete;
  final TutorController _tutor;

  final saved = <SavedAnswer>[].obs;
  final history = <QuestionHistoryItem>[].obs;
  final showHistory = false.obs;
  final subjectFilter = RxnString();
  final query = ''.obs;
  final expandedId = RxnInt();

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    saved.assignAll(await _getSaved());
    history.assignAll(await _getHistory());
  }

  void selectTab({required bool history}) {
    showHistory.value = history;
    subjectFilter.value = null;
  }

  List<SubjectFilter> get filters {
    final seen = <String, String>{};
    for (final a in saved) {
      final s = a.source;
      if (s != null) seen[s.subjectId] = s.subjectName;
    }
    return [for (final e in seen.entries) SubjectFilter(e.key, e.value)];
  }

  List<SavedAnswer> get filteredSaved {
    final id = subjectFilter.value;
    return id == null
        ? saved.toList()
        : saved.where((a) => a.source?.subjectId == id).toList();
  }

  List<HistoryGroup> historyGroups({DateTime? now}) {
    final text = ArabicNormalizer.normalize(query.value);
    final today = now ?? DateTime.now();
    final groups = <String, List<QuestionHistoryItem>>{};
    for (final item in history) {
      final matches = text.isEmpty ||
          ArabicNormalizer.normalize(item.question).contains(text);
      if (!matches) continue;
      final label = DayLabel.of(item.createdAt ?? today, now: today);
      groups.putIfAbsent(label, () => []).add(item);
    }
    return [for (final e in groups.entries) HistoryGroup(e.key, e.value)];
  }

  void toggleExpanded(SavedAnswer answer) =>
      expandedId.value = expandedId.value == answer.id ? null : answer.id;

  Future<void> remove(SavedAnswer answer) async {
    final id = answer.id;
    if (id == null) return;
    await _delete(id);
    saved.remove(answer);
  }

  void openInTutor(QuestionHistoryItem item) => _tutor.showHistoryItem(item);
}
