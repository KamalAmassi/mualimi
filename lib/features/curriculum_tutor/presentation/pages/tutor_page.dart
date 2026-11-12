import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/state_message.dart';
import '../../../content_manager/presentation/widgets/model_download_card.dart';
import '../../domain/entities/quick_action.dart';
import '../controllers/tutor_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/lesson_picker_sheet.dart';
import '../widgets/report_sheet.dart';

/// Shell tab 2. One screen covering the design's chat, empty, setup, loading,
/// search-only and math states.
class TutorPage extends GetView<TutorController> {
  const TutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.lessonTitle.value ?? AppStrings.smartTutor)),
        actions: [
          IconButton(
            tooltip: AppStrings.chooseLesson,
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: showLessonPickerSheet,
          ),
          IconButton(
            tooltip: AppStrings.saved,
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => Get.toNamed<void>(AppRoutes.saved),
          ),
          IconButton(
            tooltip: AppStrings.newChat,
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: controller.newChat,
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.canAsk) return const _Setup();
        if (!controller.tutorSupported.value) {
          return const StateMessage(icon: Icons.functions, title: AppStrings.mathSoon);
        }
        return Column(children: [
          if (controller.isLoadingModel) const _Banner(AppStrings.tutorLoading),
          if (controller.isSearchOnly) const _Banner(AppStrings.deviceTooWeak),
          Expanded(child: _Messages(controller: controller)),
          if (controller.hasLesson) _QuickActions(controller: controller),
          _Composer(controller: controller),
        ]);
      }),
    );
  }
}

class _Setup extends StatelessWidget {
  const _Setup();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSizes.pagePadding),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppStrings.tutorNeedsSetup),
        SizedBox(height: AppSizes.lg),
        ModelDownloadCard(),
      ]),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      color: c.infoContainer,
      child: Text(text, style: TextStyle(color: c.onInfoContainer)),
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages({required this.controller});
  final TutorController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(padding: const EdgeInsets.all(AppSizes.lg), children: [
          for (final m in controller.messages)
            ChatBubble(
              message: m,
              saved: controller.savedIds.contains(m.id),
              onSave: () => controller.save(m),
              onReport: () => showReportSheet(m, lessonId: controller.lessonId.value),
            ),
        ]));
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.controller});
  final TutorController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: AppSizes.sm, children: [
      for (final (action, label) in const [
        (QuickAction.explain, AppStrings.explainAction),
        (QuickAction.summary, AppStrings.summaryAction),
        (QuickAction.terms, AppStrings.termsAction),
      ])
        ActionChip(label: Text(label), onPressed: () => controller.quickAction(action, label)),
    ]);
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller});
  final TutorController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: controller.input,
            decoration: const InputDecoration(hintText: AppStrings.askHint),
            onSubmitted: (_) => controller.send(),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Obx(() => controller.isGenerating.value
            ? IconButton.filled(
                tooltip: AppStrings.stop,
                icon: const Icon(Icons.stop),
                onPressed: controller.stop,
              )
            : IconButton.filled(
                tooltip: AppStrings.send,
                icon: const Icon(Icons.send),
                onPressed: controller.send,
              )),
      ]),
    );
  }
}
