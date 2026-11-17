import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'profile_dimens.dart';

/// A small grey title over a bordered card whose rows are split by inset lines.
/// With [boxed] false the children sit directly under the title.
class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
    this.boxed = true,
  });

  final String title;
  final List<Widget> children;
  final bool boxed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: ProfileDimens.sectionTitleInset),
        child: Text(title,
            style: TextStyle(
                fontSize: ProfileDimens.sectionTitleFontSize,
                fontWeight: FontWeight.w600,
                color: c.textSecondary)),
      ),
      const SizedBox(height: AppSizes.sm),
      if (!boxed)
        ...children
      else
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: c.surface,
            border: Border.all(color: c.outline),
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: Column(children: [
            for (final (index, child) in children.indexed) ...[
              if (index > 0)
                Divider(
                    height: 1,
                    thickness: 1,
                    color: c.outline,
                    indent: ProfileDimens.dividerInset),
              child,
            ],
          ]),
        ),
    ]);
  }
}