import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/viewer_tab.dart';
import 'viewer_dimens.dart';

/// Segmented explanation / book PDF / solutions switch under the header.
class ViewerTabBar extends StatelessWidget {
  const ViewerTabBar({super.key, required this.selected, required this.onSelect});

  final ViewerTab selected;
  final ValueChanged<ViewerTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outline, width: ViewerDimens.dividerWidth)),
      ),
      child: Padding(
        padding: ViewerDimens.tabStripPadding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.surfaceVariant,
            borderRadius: BorderRadius.circular(ViewerDimens.tabTrackRadius),
          ),
          child: Padding(
            padding: ViewerDimens.tabTrackPadding,
            child: Row(children: [
              for (final tab in ViewerTab.values) Expanded(child: _tab(tab, c)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _tab(ViewerTab tab, AppColors c) {
    final isSelected = tab == selected;
    final radius = BorderRadius.circular(ViewerDimens.tabRadius);
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? c.surface : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: () => onSelect(tab),
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: ViewerDimens.tabMinHeight),
            child: Center(
              child: Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ViewerDimens.tabTextSize,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? c.textPrimary : c.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
