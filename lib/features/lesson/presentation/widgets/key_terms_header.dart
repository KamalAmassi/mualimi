import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'key_terms_dimens.dart';
import 'key_terms_strings.dart';

class KeyTermsHeader extends StatelessWidget {
  const KeyTermsHeader({super.key, required this.subtitle, required this.onBack});

  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outline, width: KeyTermsDimens.headerBorder)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            KeyTermsDimens.headerSidePadding,
            KeyTermsDimens.headerTopPadding,
            KeyTermsDimens.headerSidePadding,
            KeyTermsDimens.headerBottomPadding,
          ),
          child: Row(children: [
            SizedBox.square(
              dimension: KeyTermsDimens.backSize,
              child: IconButton(
                onPressed: onBack,
                tooltip: KeyTermsStrings.back,
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(KeyTermsDimens.backRadius),
                  ),
                ),
                icon: Icon(Icons.chevron_right, size: KeyTermsDimens.backIcon, color: c.textPrimary),
              ),
            ),
            const SizedBox(width: KeyTermsDimens.navIconGap),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  KeyTermsStrings.title,
                  style: TextStyle(
                    fontSize: KeyTermsDimens.titleFontSize,
                    fontWeight: FontWeight.w700,
                    height: KeyTermsDimens.titleLineHeight,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: KeyTermsDimens.subtitleGap),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: KeyTermsDimens.subtitleFontSize, color: c.textSecondary),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
