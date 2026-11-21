import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/usecases/get_lesson_prerequisites_usecase.dart';
import '../bindings/gap_filling_binding.dart';
import '../controllers/lesson_prerequisites_controller.dart';
import '../controllers/skill_progress_signal.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';
import 'skill_tile.dart';

/// "قبل ما تبدأ، راجع:" with the weak prerequisites of [lessonId]. Shows
/// nothing when there are none. The lesson page only places it.
class LessonPrerequisitesCard extends StatefulWidget {
  const LessonPrerequisitesCard(this.lessonId, {super.key});

  final String lessonId;

  @override
  State<LessonPrerequisitesCard> createState() => _LessonPrerequisitesCardState();
}

class _LessonPrerequisitesCardState extends State<LessonPrerequisitesCard> {
  late final LessonPrerequisitesController _controller;

  @override
  void initState() {
    super.initState();
    GapFillingBinding().dependencies();
    _controller = Get.put(
      LessonPrerequisitesController(Get.find<GetLessonPrerequisitesUseCase>(),
          Get.find<SkillProgressSignal>(), widget.lessonId),
      tag: widget.lessonId,
    );
  }

  @override
  void dispose() {
    Get.delete<LessonPrerequisitesController>(tag: widget.lessonId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final skills = _controller.skills.toList();
      if (skills.isEmpty) return const SizedBox.shrink();
      return AppCard(
        color: c.warningContainer,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            GapFillingStrings.prerequisitesTitle,
            style: TextStyle(
              fontSize: GapFillingDimens.bodySize,
              fontWeight: FontWeight.w700,
              color: c.onWarningContainer,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: skills.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, i) => SkillTile(
                skill: skills[i], onTap: () => _controller.openReview(skills[i])),
          ),
        ]),
      );
    });
  }
}
