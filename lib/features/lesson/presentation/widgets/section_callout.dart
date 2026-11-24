import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/callout_kind.dart';
import '../../domain/entities/section_inline.dart';
import 'section_body_dimens.dart';
import 'section_rich_text.dart';

/// The remember callout follows Viewer.html; the warning callout has the same
/// shape in the warning colours.
class SectionCallout extends StatelessWidget {
  const SectionCallout({
    super.key,
    required this.kind,
    required this.inlines,
    required this.fontScale,
  });

  final CalloutKind kind;
  final List<SectionInline> inlines;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (container, accent, onContainer, icon) = switch (kind) {
      CalloutKind.remember => (c.infoContainer, c.info, c.onInfoContainer, Icons.lightbulb_outline),
      CalloutKind.warning => (
          c.warningContainer,
          c.warning,
          c.onWarningContainer,
          Icons.warning_amber_rounded,
        ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.circular(SectionBodyDimens.calloutRadius),
      ),
      child: Padding(
        padding: SectionBodyDimens.calloutPadding,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: SectionBodyDimens.calloutIcon, color: accent),
          const SizedBox(width: SectionBodyDimens.calloutGap),
          Expanded(
            child: SectionRichText(
              inlines: inlines,
              style: TextStyle(
                fontSize: SectionBodyDimens.calloutTextSize * fontScale,
                height: SectionBodyDimens.calloutLineHeight,
                color: onContainer,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
