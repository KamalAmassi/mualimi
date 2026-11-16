import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/question_history_item.dart';
import '../controllers/saved_controller.dart';
import 'tutor_sizes.dart';

/// One day of question history as a rounded list.
class HistoryGroupView extends StatelessWidget {
  const HistoryGroupView(
      {super.key, required this.group, required this.onOpen});

  final HistoryGroup group;
  final ValueChanged<QuestionHistoryItem> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding:
            const EdgeInsets.fromLTRB(AppSizes.xs, 6, AppSizes.xs, AppSizes.sm),
        child: Text(group.label,
            style: TextStyle(
                fontSize: TutorSizes.textChip,
                fontWeight: FontWeight.w600,
                color: c.textSecondary)),
      ),
      Container(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.outline),
          borderRadius: BorderRadius.circular(AppSizes.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          for (var i = 0; i < group.items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: c.outline),
            _Tile(item: group.items[i], onTap: () => onOpen(group.items[i])),
          ],
        ]),
      ),
    ]);
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item, required this.onTap});

  final QuestionHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final created = item.createdAt;
    final subject = item.source?.subjectName ?? '';
    final time = created == null
        ? ''
        : MaterialLocalizations.of(context)
            .formatTimeOfDay(TimeOfDay.fromDateTime(created));
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: AppSizes.md),
        child: Row(children: [
          Container(
            width: TutorSizes.subjectDot,
            height: TutorSizes.subjectDot,
            decoration:
                BoxDecoration(color: c.subjectScience, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.question,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      color: c.textPrimary)),
              Text('$subject · $time',
                  style: TextStyle(
                      fontSize: TutorSizes.textSmall, color: c.textSecondary)),
            ]),
          ),
          Icon(LucideIcons.chevronLeft,
              size: AppSizes.xl - 2, color: c.textSecondary),
        ]),
      ),
    );
  }
}
