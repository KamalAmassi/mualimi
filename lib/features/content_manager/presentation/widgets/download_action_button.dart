import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import 'download_icon.dart';

/// Visual style of a [DownloadActionButton].
enum DownloadButtonVariant { filled, outlined }

/// Full-width 54-high footer button with an optional leading SVG icon.
/// Disabled when [onPressed] is null.
class DownloadActionButton extends StatelessWidget {
  const DownloadActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconPath,
    this.variant = DownloadButtonVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;

  /// SVG path data from [DownloadIcons]; no icon when null.
  final String? iconPath;
  final DownloadButtonVariant variant;

  bool get _filled => variant == DownloadButtonVariant.filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    final background = _filled ? c.primary : c.surface;
    final foreground = enabled ? (_filled ? c.onPrimary : c.textPrimary) : c.textSecondary;
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(DownloadDimens.buttonHeight)),
      padding: const WidgetStatePropertyAll(
        EdgeInsetsDirectional.symmetric(horizontal: DownloadDimens.buttonPaddingHorizontal),
      ),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(enabled || !_filled ? background : c.outline),
      foregroundColor: WidgetStatePropertyAll(foreground),
      overlayColor: WidgetStatePropertyAll(foreground.withValues(alpha: 0.08)),
      side: WidgetStatePropertyAll(
        _filled
            ? BorderSide.none
            : BorderSide(color: c.outline, width: DownloadDimens.outlinedButtonBorderWidth),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _filled ? DownloadDimens.filledButtonRadius : DownloadDimens.outlinedButtonRadius,
          ),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: _filled ? DownloadDimens.filledButtonFontSize : DownloadDimens.outlinedButtonFontSize,
          fontWeight: _filled ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
    final icon = iconPath;
    return TextButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            DownloadIcon(icon, color: foreground),
            const SizedBox(width: DownloadDimens.buttonGap),
          ],
          Flexible(child: Text(label, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
