import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/state_message.dart';
import '../controllers/key_terms_controller.dart';
import '../widgets/key_term_flip_card.dart';
import '../widgets/key_term_list_row.dart';
import '../widgets/key_terms_dimens.dart';
import '../widgets/key_terms_header.dart';
import '../widgets/key_terms_nav_buttons.dart';
import '../widgets/key_terms_strings.dart';

class KeyTermsPage extends GetView<KeyTermsController> {
  const KeyTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Obx(() => Column(children: [
            KeyTermsHeader(
              subtitle: KeyTermsStrings.subtitle(controller.lessonTitle.value, controller.terms.length),
              onBack: Get.back,
            ),
            Expanded(child: _body(context)),
          ])),
    );
  }

  Widget _body(BuildContext context) {
    if (controller.loading.value) return const SizedBox.shrink();
    if (controller.terms.isEmpty) {
      return const StateMessage(icon: Icons.style_outlined, title: KeyTermsStrings.empty);
    }
    final c = context.colors;
    final terms = controller.terms;
    const side = EdgeInsets.symmetric(horizontal: AppSizes.lg);
    return CustomScrollView(controller: controller.scrollController, slivers: [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          KeyTermsDimens.bodyVerticalPadding,
          AppSizes.lg,
          KeyTermsDimens.bodyGap,
        ),
        sliver: SliverList.list(children: [
          KeyTermFlipCard(
            term: controller.current,
            position: controller.index.value,
            counter: KeyTermsStrings.counter(controller.index.value + 1, terms.length),
            showingDefinition: controller.showingDefinition.value,
            onTap: controller.flip,
          ),
          const SizedBox(height: KeyTermsDimens.bodyGap),
          KeyTermsNavButtons(
            onPrevious: controller.hasPrevious ? controller.previous : null,
            onNext: controller.hasNext ? controller.next : null,
          ),
          const SizedBox(height: KeyTermsDimens.bodyGap + KeyTermsDimens.allTermsTopGap),
          Text(
            KeyTermsStrings.allTerms,
            style: TextStyle(
              fontSize: KeyTermsDimens.allTermsFontSize,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ]),
      ),
      SliverPadding(
        padding: side,
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border.all(color: c.outline, width: KeyTermsDimens.listBorder),
            borderRadius: BorderRadius.circular(KeyTermsDimens.listRadius),
          ),
          sliver: SliverPadding(
            padding: const EdgeInsets.all(KeyTermsDimens.listBorder),
            sliver: SliverList.builder(
              itemCount: terms.length,
              itemBuilder: (context, i) => KeyTermListRow(
                term: terms[i],
                first: i == 0,
                onTap: () => controller.showCard(i),
              ),
            ),
          ),
        ),
      ),
      const SliverPadding(padding: EdgeInsets.only(bottom: KeyTermsDimens.bodyVerticalPadding)),
    ]);
  }
}
