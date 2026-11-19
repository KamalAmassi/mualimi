import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/saved_controller.dart';
import '../widgets/history_group_view.dart';
import '../widgets/history_search_field.dart';
import '../widgets/saved_answer_card.dart';
import '../widgets/saved_tabs.dart';
import '../widgets/subject_filter_chips.dart';
import '../widgets/tutor_sizes.dart';

class SavedPage extends GetView<SavedController> {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _Header(color: c),
          _Controls(controller: controller),
          Expanded(child: _List(controller: controller)),
        ]),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.color});
  final AppColors color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, 10),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(bottom: BorderSide(color: color.outline)),
      ),
      child: Row(children: [
        IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: Get.back<void>,
          icon: Icon(LucideIcons.arrowRight, color: color.textPrimary),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppStrings.saved,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color.textPrimary)),
            Text(AppStrings.savedSubtitle,
                style: TextStyle(
                    fontSize: TutorSizes.textSmall,
                    color: color.textSecondary)),
          ]),
        ),
      ]),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.controller});
  final SavedController controller;

  @override
  Widget build(BuildContext context) => Obx(() => _content(context));

  Widget _content(BuildContext context) {
    final history = controller.showHistory.value;
    return Container(
      color: context.colors.surface,
      padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.md),
      child: Column(children: [
        SavedTabs(
            historySelected: history,
            onSelect: (h) => controller.selectTab(history: h)),
        const SizedBox(height: 10),
        if (history)
          HistorySearchField(onChanged: (v) => controller.query.value = v)
        else if (controller.saved.isNotEmpty)
          SubjectFilterChips(
            filters: controller.filters,
            selectedId: controller.subjectFilter.value,
            onSelect: (id) => controller.subjectFilter.value = id,
          ),
      ]),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.controller});
  final SavedController controller;

  @override
  Widget build(BuildContext context) => Obx(() => _content());

  Widget _content() {
    if (controller.showHistory.value) {
      final groups = controller.historyGroups();
      if (groups.isEmpty) {
        return const StateMessage(
            icon: LucideIcons.search, title: AppStrings.historyEmptyTitle);
      }
      return ListView.builder(
        padding: const EdgeInsets.all(AppSizes.lg),
        itemCount: groups.length,
        itemBuilder: (context, i) =>
            HistoryGroupView(group: groups[i], onOpen: controller.openInTutor),
      );
    }
    final answers = controller.filteredSaved;
    if (answers.isEmpty) {
      return StateMessage(
        icon: LucideIcons.bookmark,
        title: AppStrings.savedEmptyTitle,
        message: AppStrings.savedEmptyBody,
        actionLabel: AppStrings.askTutor,
        onAction: Get.back<void>,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.lg),
      itemCount: answers.length,
      itemBuilder: (context, i) {
        final answer = answers[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SavedAnswerCard(
            answer: answer,
            expanded: controller.expandedId.value == answer.id,
            onTap: () => controller.toggleExpanded(answer),
            onDelete: () => controller.remove(answer),
          ),
        );
      },
    );
  }
}
