import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import 'subject_dimens.dart';
import 'subject_header_button.dart';
import 'subject_icon_box.dart';
import 'subject_strings.dart';

/// Purple header: back, ask the tutor, subject icon, name, grade and unit count.
class SubjectHeader extends StatelessWidget {
  const SubjectHeader({
    super.key,
    required this.subjectId,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.onAskTutor,
  });

  final String subjectId;
  final String title;
  final String? subtitle;
  final VoidCallback onBack;

  /// Null hides the button (subjects the tutor can't handle yet).
  final VoidCallback? onAskTutor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ColoredBox(
      color: c.hero,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          SubjectDimens.headerPaddingH,
          SubjectDimens.headerPaddingTop + MediaQuery.paddingOf(context).top,
          SubjectDimens.headerPaddingH,
          SubjectDimens.headerPaddingBottom,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            SubjectHeaderButton(
              icon: LucideIcons.chevronRight,
              iconSize: SubjectDimens.backIcon,
              tooltip: SubjectStrings.back,
              onPressed: onBack,
            ),
            const Spacer(),
            if (onAskTutor != null)
              SubjectHeaderButton(
                icon: LucideIcons.sparkles,
                iconSize: SubjectDimens.askIcon,
                tooltip: SubjectStrings.askTutorAboutSubject,
                onPressed: onAskTutor!,
                filled: true,
              ),
          ]),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                SubjectDimens.titleRowH, SubjectDimens.titleRowTop, SubjectDimens.titleRowH, 0),
            child: Row(children: [
              SubjectIconBox(
                subjectId: subjectId,
                size: SubjectDimens.iconBox,
                radius: SubjectDimens.iconBoxRadius,
                iconSize: SubjectDimens.icon,
                background: c.surface,
              ),
              const SizedBox(width: SubjectDimens.titleRowGap),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: SubjectDimens.titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: c.onHero)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: TextStyle(
                            fontSize: SubjectDimens.subtitleFontSize, color: c.onHeroMuted)),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
