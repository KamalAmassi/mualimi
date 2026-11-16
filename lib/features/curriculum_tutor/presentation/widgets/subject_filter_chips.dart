import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/saved_controller.dart';
import 'tutor_sizes.dart';

class SubjectFilterChips extends StatelessWidget {
  const SubjectFilterChips({
    super.key,
    required this.filters,
    required this.selectedId,
    required this.onSelect,
  });

  final List<SubjectFilter> filters;
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TutorSizes.filterChipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, i) {
          final filter = i == 0 ? null : filters[i - 1];
          return _FilterChip(
            label: filter?.name ?? AppStrings.allSubjects,
            selected: selectedId == filter?.id,
            onTap: () => onSelect(filter?.id),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: selected ? c.primary : c.surface,
      shape: StadiumBorder(
          side: selected ? BorderSide.none : BorderSide(color: c.outline)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg - 2),
          child: Text(label,
              style: TextStyle(
                fontSize: TutorSizes.textChip,
                fontWeight: FontWeight.w600,
                color: selected ? c.onPrimary : c.textPrimary,
              )),
        ),
      ),
    );
  }
}
