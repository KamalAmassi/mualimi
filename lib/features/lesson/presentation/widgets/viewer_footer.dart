import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'viewer_dimens.dart';
import 'viewer_footer_button.dart';
import 'viewer_strings.dart';

/// Previous, explain-this-section and next, under the explanation.
class ViewerFooter extends StatelessWidget {
  const ViewerFooter({
    super.key,
    required this.onPrevious,
    required this.onExplain,
    required this.onNext,
  });

  /// Each callback is null when its action is unavailable.
  final VoidCallback? onPrevious;
  final VoidCallback? onExplain;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.outline, width: ViewerDimens.dividerWidth)),
      ),
      child: Padding(
        padding: ViewerDimens.footerPadding,
        child: Row(children: [
          ViewerFooterButton(
            label: ViewerStrings.previous,
            icon: Icons.chevron_left,
            onPressed: onPrevious,
            background: c.surface,
            foreground: c.textPrimary,
            border: c.outline,
          ),
          const SizedBox(width: ViewerDimens.footerGap),
          Expanded(
            child: ViewerFooterButton(
              label: ViewerStrings.explainSection,
              icon: Icons.auto_awesome,
              onPressed: onExplain,
              background: c.tint,
              foreground: c.primary,
              bold: true,
              iconGap: ViewerDimens.explainIconGap,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: ViewerDimens.footerGap),
          ViewerFooterButton(
            label: ViewerStrings.next,
            icon: Icons.chevron_right,
            onPressed: onNext,
            background: c.primary,
            foreground: c.onPrimary,
            iconAfterLabel: true,
          ),
        ]),
      ),
    );
  }
}
