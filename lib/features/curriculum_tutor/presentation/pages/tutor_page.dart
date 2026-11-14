import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../controllers/tutor_controller.dart';
import '../widgets/composer.dart';
import '../widgets/empty_tutor_view.dart';
import '../widgets/lesson_picker_sheet.dart';
import '../widgets/math_unavailable_view.dart';
import '../widgets/message_list.dart';
import '../widgets/quick_action_chips.dart';
import '../widgets/scope_bar.dart';
import '../widgets/stop_generation_button.dart';
import '../widgets/tutor_header.dart';

/// Shell tab 2: the chat with the tutor.
class TutorPage extends GetView<TutorController> {
  const TutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = controller.selection;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          Obx(() => TutorHeader(
                online: controller.engineState.value == TutorEngineState.ready,
                onOpenSaved: () => Get.toNamed<void>(AppRoutes.saved),
              )),
          Obx(() => ScopeBar(
                subjectName: selection.subjectName,
                lessonTitle: selection.lessonTitle.value,
                supported: selection.supported.value,
                onPick: showLessonPickerSheet,
                onClearLesson: selection.clearLesson,
              )),
          Expanded(child: Obx(_body)),
          Obx(() => _bottom(context)),
        ]),
      ),
    );
  }

  Widget _body() {
    final selection = controller.selection;
    if (!selection.supported.value) {
      return MathUnavailableView(
        subjectName: selection.subjectName,
        onOpenSubject: controller.openSubject,
        onChooseOther: showLessonPickerSheet,
      );
    }
    if (controller.messages.isEmpty) {
      return EmptyTutorView(
        subjectName: selection.subjectName,
        examples: controller.examples.toList(),
        onExample: controller.ask,
      );
    }
    return MessageList(controller: controller);
  }

  Widget _bottom(BuildContext context) {
    final selection = controller.selection;
    final supported = selection.supported.value;
    return Container(
      color: context.colors.background,
      padding: const EdgeInsets.fromLTRB(AppSizes.md, 10, AppSizes.md, 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (controller.isGenerating.value) ...[
          StopGenerationButton(onPressed: controller.stop),
          const SizedBox(height: 10),
        ],
        if (supported) ...[
          QuickActionChips(
            enabled: selection.hasLesson && !controller.isGenerating.value,
            onSelected: controller.quickAction,
          ),
          const SizedBox(height: 10),
        ],
        Composer(
          input: controller.input,
          enabled: supported,
          hint: supported ? AppStrings.askHint : AppStrings.mathComposerHint,
          onSend: controller.send,
        ),
      ]),
    );
  }
}
