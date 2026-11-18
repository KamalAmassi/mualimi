import 'package:flutter/material.dart';

import '../../domain/entities/subject.dart';
import 'home_dimens.dart';
import 'subject_card.dart';

/// Two subject cards side by side, stretched to the taller one so larger
/// text never clips either card.
class SubjectsGridRow extends StatelessWidget {
  const SubjectsGridRow({
    super.key,
    required this.subjects,
    required this.isFirst,
    required this.onOpen,
  });

  final List<Subject> subjects;
  final bool isFirst;
  final ValueChanged<Subject> onOpen;

  @override
  Widget build(BuildContext context) {
    Widget cell(int i) => Expanded(
          child: i < subjects.length
              ? SubjectCard(subject: subjects[i], onTap: () => onOpen(subjects[i]))
              : const SizedBox.shrink(),
        );
    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0 : HomeDimens.gridGap),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          cell(0),
          const SizedBox(width: HomeDimens.gridGap),
          cell(1),
        ]),
      ),
    );
  }
}
