import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/usecases/get_learning_path_usecase.dart';
import '../bindings/gap_filling_binding.dart';
import '../controllers/learning_path_controller.dart';
import '../controllers/skill_progress_signal.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';
import 'skill_tile.dart';

/// "مسارك": what to review next. Home only places it.
class LearningPathCard extends StatefulWidget {
  const LearningPathCard({super.key});

  @override
  State<LearningPathCard> createState() => _LearningPathCardState();
}

class _LearningPathCardState extends State<LearningPathCard> {
  late final LearningPathController _controller;

  @override
  void initState() {
    super.initState();
    GapFillingBinding().dependencies();
    _controller = Get.put(LearningPathController(
        Get.find<GetLearningPathUseCase>(), Get.find<SkillProgressSignal>()));
  }

  @override
  void dispose() {
    Get.delete<LearningPathController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final path = _controller.path.value;
      if (path == null) return const SizedBox.shrink();
      if (!path.diagnosticTaken) {
        return AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(GapFillingStrings.pathInviteTitle, style: _title(c)),
            const SizedBox(height: AppSizes.md),
            PrimaryButton(
              label: GapFillingStrings.pathInviteAction,
              onPressed: _controller.openDiagnostic,
            ),
          ]),
        );
      }
      final skills = path.shown;
      if (skills.isEmpty) {
        return AppCard(
          color: c.successContainer,
          child: Text(GapFillingStrings.pathAllGood,
              style: _title(c).copyWith(color: c.onSuccessContainer)),
        );
      }
      return AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(GapFillingStrings.pathCardTitle, style: _title(c)),
          const SizedBox(height: AppSizes.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: skills.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, i) =>
                SkillTile(skill: skills[i], onTap: () => _controller.openReview(skills[i])),
          ),
        ]),
      );
    });
  }

  TextStyle _title(AppColors c) => TextStyle(
        fontSize: GapFillingDimens.bodySize,
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
      );
}
