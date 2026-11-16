import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'tutor_sizes.dart';

/// A radio-style row used by the report reasons and the lesson list.
class ReasonRow extends StatelessWidget {
  const ReasonRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.caption,
  });

  final String label;
  final String? caption;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppSizes.md);
    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        constraints: const BoxConstraints(minHeight: TutorSizes.rowHeight),
        padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 6),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: selected ? c.tint : Colors.transparent,
          borderRadius: radius,
        ),
        child: Row(children: [
          Container(
            width: TutorSizes.radio,
            height: TutorSizes.radio,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: selected ? c.primary : c.outlineStrong, width: 2),
            ),
            child: selected
                ? Container(
                    width: TutorSizes.radioDot,
                    height: TutorSizes.radioDot,
                    decoration:
                        BoxDecoration(color: c.primary, shape: BoxShape.circle),
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: c.textPrimary)),
              if (caption != null)
                Text(caption!,
                    style: TextStyle(
                        fontSize: TutorSizes.textSmall,
                        color: c.textSecondary)),
            ]),
          ),
        ]),
      ),
    );
  }
}
