import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/primary_button.dart';
import 'gap_filling_dimens.dart';
import 'gap_filling_strings.dart';

class ReviewResultView extends StatelessWidget {
  const ReviewResultView({
    super.key,
    required this.stillWeak,
    required this.fromLesson,
    required this.onAgain,
    required this.onLeave,
  });

  final bool stillWeak;
  final bool fromLesson;
  final VoidCallback onAgain;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final leaveLabel = fromLesson && !stillWeak
        ? GapFillingStrings.backToLesson
        : GapFillingStrings.back;
    return Padding(
      padding: GapFillingDimens.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              stillWeak ? LucideIcons.heart : LucideIcons.partyPopper,
              size: GapFillingDimens.heroIconSize,
              color: stillWeak ? c.primary : c.success,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              stillWeak ? GapFillingStrings.reviewTryLater : GapFillingStrings.reviewStronger,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: GapFillingDimens.questionSize,
                fontWeight: FontWeight.w700,
                height: GapFillingDimens.miniLessonLineHeight,
                color: c.textPrimary,
              ),
            ),
          ]),
        ),
        if (stillWeak) ...[
          SizedBox(
            height: AppSizes.buttonHeight,
            child: PrimaryButton(label: GapFillingStrings.reviewAgain, onPressed: onAgain),
          ),
          const SizedBox(height: AppSizes.sm),
          SizedBox(
            height: AppSizes.buttonHeight,
            child: PrimaryButton(
                label: leaveLabel, outlined: true, onPressed: onLeave),
          ),
        ] else
          SizedBox(
            height: AppSizes.buttonHeight,
            child: PrimaryButton(label: leaveLabel, onPressed: onLeave),
          ),
      ]),
    );
  }
}
