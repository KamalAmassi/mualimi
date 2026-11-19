import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/viewer_controller.dart';
import '../controllers/viewer_tab.dart';
import '../widgets/viewer_dimens.dart';
import '../widgets/viewer_footer.dart';
import '../widgets/viewer_header.dart';
import '../widgets/viewer_section_article.dart';
import '../widgets/viewer_strings.dart';
import '../widgets/viewer_tab_bar.dart';

class ViewerPage extends GetView<ViewerController> {
  const ViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Obx(() {
          final tab = controller.tab.value;
          final onExplanation = tab == ViewerTab.explanation;
          final hasSection = controller.currentSection != null;
          return Column(children: [
            _chrome(ViewerHeader(
              title: controller.lesson.value?.title ?? '',
              counter: hasSection
                  ? ViewerStrings.sectionCounter(
                      controller.sectionIndex.value + 1, controller.sections.length)
                  : null,
              onClose: () => Get.back<void>(),
              onFontSize: onExplanation ? controller.cycleFontScale : null,
            )),
            _chrome(ViewerTabBar(selected: tab, onSelect: controller.select)),
            Expanded(child: _body(tab)),
            if (onExplanation && hasSection)
              _chrome(ViewerFooter(
                onPrevious: controller.canGoPrevious ? controller.goToPrevious : null,
                onExplain: controller.tutorEnabled.value ? controller.explainSection : null,
                onNext: controller.canGoNext ? controller.goToNext : null,
              )),
          ]);
        }),
      ),
    );
  }

  Widget _chrome(Widget child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: ViewerDimens.chromeMaxTextScale,
        child: child,
      );

  // TODO(pdfx): render the book pages for the pdf tab.
  Widget _body(ViewerTab tab) => switch (tab) {
        ViewerTab.explanation => _explanation(),
        ViewerTab.pdf => Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Text(controller.lesson.value?.pdfFile ?? ''),
          ),
        ViewerTab.solutions => ListView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            children: [
              for (final s in controller.solutions) Text('${s.number} (${s.page}): ${s.solution}'),
            ],
          ),
      };

  Widget _explanation() {
    final section = controller.currentSection;
    if (section != null) {
      return ViewerSectionArticle(
        key: ValueKey(controller.sectionIndex.value),
        section: section,
        fontScale: controller.fontScale.value,
      );
    }
    if (controller.loading.value) return const Center(child: CircularProgressIndicator());
    if (controller.lesson.value == null && controller.failure.value != null) {
      return StateMessage(
        icon: Icons.error_outline,
        title: ViewerStrings.loadFailed,
        actionLabel: AppStrings.retry,
        onAction: controller.load,
      );
    }
    return const StateMessage(icon: Icons.menu_book_outlined, title: ViewerStrings.empty);
  }
}
