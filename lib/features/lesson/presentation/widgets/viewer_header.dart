import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'viewer_dimens.dart';
import 'viewer_strings.dart';

/// Close button, lesson title with the section counter, and the Aa button.
class ViewerHeader extends StatelessWidget {
  const ViewerHeader({
    super.key,
    required this.title,
    required this.onClose,
    this.counter,
    this.onFontSize,
  });

  final String title;
  final String? counter;
  final VoidCallback onClose;

  /// Null hides the Aa button; its slot stays so the title remains centred.
  final VoidCallback? onFontSize;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ColoredBox(
      color: c.surface,
      child: Padding(
        padding: ViewerDimens.headerPadding,
        child: Row(children: [
          _iconButton(Icons.close, ViewerStrings.close, onClose, c),
          const SizedBox(width: ViewerDimens.headerGap),
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ViewerDimens.titleSize,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              if (counter != null)
                Text(
                  counter!,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: ViewerDimens.counterSize, color: c.textSecondary),
                ),
            ]),
          ),
          const SizedBox(width: ViewerDimens.headerGap),
          if (onFontSize == null)
            const SizedBox(width: ViewerDimens.headerTapTarget)
          else
            _iconButton(Icons.format_size, ViewerStrings.fontSize, onFontSize!, c),
        ]),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback onPressed, AppColors c) {
    return IconButton(
      onPressed: onPressed,
      tooltip: label,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(const Size.square(ViewerDimens.headerTapTarget)),
      iconSize: ViewerDimens.headerIcon,
      color: c.textPrimary,
      icon: Icon(icon),
    );
  }
}
