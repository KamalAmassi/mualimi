import 'package:flutter/material.dart';

import 'viewer_dimens.dart';

/// A 48px footer button; the icon sits before or after its label.
class ViewerFooterButton extends StatelessWidget {
  const ViewerFooterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.background,
    required this.foreground,
    this.border,
    this.iconAfterLabel = false,
    this.bold = false,
    this.iconGap = ViewerDimens.buttonIconGap,
    this.padding = ViewerDimens.buttonPadding,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final Color? border;
  final bool iconAfterLabel;
  final bool bold;
  final double iconGap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(ViewerDimens.buttonRadius);
    final children = [
      Icon(icon, size: ViewerDimens.buttonIcon, color: foreground),
      SizedBox(width: iconGap),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ViewerDimens.buttonTextSize,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: foreground,
          ),
        ),
      ),
    ];
    return Opacity(
      opacity: onPressed == null ? ViewerDimens.disabledOpacity : 1,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border == null
              ? BorderSide.none
              : BorderSide(color: border!, width: ViewerDimens.dividerWidth),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Padding(
            padding: padding,
            child: SizedBox(
              height: ViewerDimens.buttonHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconAfterLabel ? children.reversed.toList() : children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
