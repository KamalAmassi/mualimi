import 'package:flutter/material.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../controllers/profile_controller.dart';
import 'change_grade_note.dart';
import 'change_grade_tile.dart';
import 'profile_sheet_button.dart';
import 'profile_sheet_dimens.dart';
import 'profile_sheet_header.dart';
import 'profile_sheet_strings.dart';

Future<void> showChangeGradeSheet(ProfileController controller) =>
    showAppBottomSheet<void>(ChangeGradeSheet(controller: controller));

/// Grades 7–12. Picking another offered grade enables the download button;
/// the current grade is never re-downloaded from here.
class ChangeGradeSheet extends StatefulWidget {
  const ChangeGradeSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  State<ChangeGradeSheet> createState() => _ChangeGradeSheetState();
}

class _ChangeGradeSheetState extends State<ChangeGradeSheet> {
  static const _grades = [7, 8, 9, 10, 11, 12];

  int? _picked;

  int? get _current => widget.controller.current.grade;

  bool _canPick(int grade) => grade != _current && AppConfig.availableGrades.contains(grade);

  Future<void> _confirm(int grade) async {
    Navigator.of(context).pop();
    await widget.controller.changeGrade(grade);
  }

  Widget _tile(int grade) {
    final isCurrent = grade == _current;
    return ChangeGradeTile(
      grade: grade,
      isCurrent: isCurrent,
      available: AppConfig.availableGrades.contains(grade),
      highlighted: _picked == null ? isCurrent : grade == _picked,
      onTap: _canPick(grade) ? () => setState(() => _picked = grade) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    const columns = ProfileSheetDimens.gridColumns;
    final picked = _picked;
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ProfileSheetDimens.blockGap,
          children: [
            const ProfileSheetHeader(title: AppStrings.changeGrade),
            Column(spacing: ProfileSheetDimens.gridGap, children: [
              for (var start = 0; start < _grades.length; start += columns)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: ProfileSheetDimens.gridGap,
                    children: [
                      for (final grade in _grades.skip(start).take(columns))
                        Expanded(child: _tile(grade)),
                    ],
                  ),
                ),
            ]),
            const ChangeGradeNote(),
            ProfileSheetButton(
              label: picked == null
                  ? ProfileSheetStrings.chooseGradeToContinue
                  : AppStrings.startDownload,
              onPressed: picked == null ? null : () => _confirm(picked),
            ),
          ],
        ),
      ),
    );
  }
}
