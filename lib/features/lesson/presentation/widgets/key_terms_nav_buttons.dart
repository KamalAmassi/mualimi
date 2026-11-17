import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'key_terms_dimens.dart';
import 'key_terms_strings.dart';

class KeyTermsNavButtons extends StatelessWidget {
  const KeyTermsNavButtons({super.key, required this.onPrevious, required this.onNext});

  /// Null when there is no card in that direction.
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: _NavButton(
          label: KeyTermsStrings.previous,
          icon: Icons.chevron_right,
          background: c.surface,
          foreground: c.textPrimary,
          border: c.outline,
          onPressed: onPrevious,
        ),
      ),
      const SizedBox(width: KeyTermsDimens.navGap),
      Expanded(
        child: _NavButton(
          label: KeyTermsStrings.next,
          background: c.tint,
          foreground: c.onTint,
          onPressed: onNext,
        ),
      ),
    ]);
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.icon,
    this.border,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color? border;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? KeyTermsDimens.disabledOpacity : 1,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(KeyTermsDimens.navHeight),
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background,
          disabledForegroundColor: foreground,
          textStyle: const TextStyle(
            fontSize: KeyTermsDimens.navFontSize,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KeyTermsDimens.navRadius),
            side: border == null
                ? BorderSide.none
                : BorderSide(color: border!, width: KeyTermsDimens.navBorder),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[
            Icon(icon, size: KeyTermsDimens.navIcon),
            const SizedBox(width: KeyTermsDimens.navIconGap),
          ],
          Flexible(child: Text(label, textAlign: TextAlign.center)),
        ]),
      ),
    );
  }
}
