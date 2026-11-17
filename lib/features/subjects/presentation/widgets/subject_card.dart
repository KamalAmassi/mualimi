import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/subject.dart';
import 'home_dimens.dart';
import 'home_strings.dart';
import 'subject_icon_box.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.subject, required this.onTap});

  final Subject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppSizes.radiusCard);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: c.outline)),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: HomeDimens.cardMinHeight),
          child: Padding(
            padding: const EdgeInsets.all(HomeDimens.cardPadding),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SubjectIconBox(subjectId: subject.id),
              const SizedBox(height: HomeDimens.cardGap),
              Text(subject.name,
                  style: TextStyle(
                      fontSize: HomeDimens.cardTitleFontSize,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary)),
              const SizedBox(height: HomeDimens.cardGap),
              subject.tutorEnabled ? _offline(c) : _tutorSoon(c),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _offline(AppColors c) => Text(HomeStrings.availableOffline,
      style: TextStyle(fontSize: HomeDimens.badgeFontSize, color: c.textSecondary));

  Widget _tutorSoon(AppColors c) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: HomeDimens.chipPaddingH, vertical: HomeDimens.chipPaddingV),
        decoration: ShapeDecoration(color: c.infoContainer, shape: const StadiumBorder()),
        child: Text(HomeStrings.tutorSoon,
            style: TextStyle(
                fontSize: HomeDimens.badgeFontSize,
                fontWeight: FontWeight.w600,
                color: c.onInfoContainer)),
      );
}
