import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'home_dimens.dart';
import 'home_strings.dart';

/// «موادّك» with the subject count on the opposite side.
class SubjectsSectionHeader extends StatelessWidget {
  const SubjectsSectionHeader({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(children: [
      Expanded(
        child: Text(HomeStrings.yourSubjects,
            style: TextStyle(
                fontSize: HomeDimens.sectionTitleFontSize,
                fontWeight: FontWeight.w700,
                color: c.textPrimary)),
      ),
      const SizedBox(width: AppSizes.sm),
      Text(HomeStrings.subjectsCount(count),
          style: TextStyle(fontSize: HomeDimens.countFontSize, color: c.textSecondary)),
    ]);
  }
}
