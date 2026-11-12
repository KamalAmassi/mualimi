import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/pending_report.dart';
import '../../domain/usecases/submit_report_usecase.dart';

class ReportController extends GetxController {
  ReportController(this._submit);
  final SubmitReportUseCase _submit;

  static const reasons = [
    AppStrings.reportReasonWrong,
    AppStrings.reportReasonOffTopic,
    AppStrings.reportReasonUnclear,
  ];

  final reason = RxnString();
  final note = TextEditingController();

  void reset() {
    reason.value = null;
    note.clear();
  }

  Future<void> submit(ChatMessage message, {String? lessonId}) async {
    final selected = reason.value;
    if (selected == null || message.question == null) return;
    await _submit(PendingReport(
      lessonId: lessonId,
      question: message.question!,
      answer: message.text,
      reason: selected,
      note: note.text.trim().isEmpty ? null : note.text.trim(),
    ));
    Get.back<void>();
  }

  @override
  void onClose() {
    note.dispose();
    super.onClose();
  }
}
