import 'package:flutter/material.dart';

import 'grade_dimens.dart';
import 'grade_tile.dart';

/// Grades 1–12 in rows of three. Rows size to their tallest tile so large
/// text scales grow the tiles instead of overflowing them.
class GradeGrid extends StatelessWidget {
  const GradeGrid({
    super.key,
    required this.isAvailable,
    required this.selected,
    required this.onSelect,
  });

  static final _grades = List<int>.generate(12, (index) => index + 1);

  final bool Function(int grade) isAvailable;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const columns = GradeDimens.gridColumns;
    return Column(
      spacing: GradeDimens.gridGap,
      children: [
        for (var start = 0; start < _grades.length; start += columns)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: GradeDimens.gridGap,
              children: [
                for (final grade in _grades.skip(start).take(columns))
                  Expanded(
                    child: GradeTile(
                      grade: grade,
                      available: isAvailable(grade),
                      selected: grade == selected,
                      onTap: () => onSelect(grade),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
