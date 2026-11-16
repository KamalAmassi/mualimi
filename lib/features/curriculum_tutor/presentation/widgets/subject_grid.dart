import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../subjects/domain/entities/subject.dart';
import 'tutor_sizes.dart';

/// Four-column grid of subjects; unsupported ones are disabled with a "soon" badge.
class SubjectGrid extends StatelessWidget {
  const SubjectGrid({
    super.key,
    required this.subjects,
    required this.selectedId,
    required this.onPick,
  });

  final List<Subject> subjects;
  final String? selectedId;
  final ValueChanged<Subject> onPick;

  static const _columns = 4;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        mainAxisExtent: TutorSizes.subjectTileHeight,
        mainAxisSpacing: AppSizes.sm,
        crossAxisSpacing: AppSizes.sm,
      ),
      itemBuilder: (context, i) => _SubjectTile(
        subject: subjects[i],
        selected: subjects[i].id == selectedId,
        onTap: () => onPick(subjects[i]),
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile(
      {required this.subject, required this.selected, required this.onTap});

  final Subject subject;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = subject.tutorEnabled;
    final radius = BorderRadius.circular(TutorSizes.subjectTileRadius);
    return Material(
      color: !enabled ? c.surfaceVariant : (selected ? c.tint : c.surface),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
            color: selected ? c.primary : c.outline, width: selected ? 2 : 1),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: radius,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (enabled)
            Container(
              width: TutorSizes.subjectIconBox,
              height: TutorSizes.subjectIconBox,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: AppSizes.xs),
              decoration: BoxDecoration(
                color: c.tintSoft,
                borderRadius: BorderRadius.circular(TutorSizes.stepBadgeRadius),
              ),
              child: Text(subject.name.characters.first,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.primaryText)),
            ),
          Text(subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: !enabled
                    ? c.textSecondary
                    : (selected ? c.onTint : c.textPrimary),
              )),
          if (!enabled)
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: c.infoContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(AppStrings.comingSoon,
                  style: TextStyle(fontSize: 10.5, color: c.onInfoContainer)),
            ),
        ]),
      ),
    );
  }
}
