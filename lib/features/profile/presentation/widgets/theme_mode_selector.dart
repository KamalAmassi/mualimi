import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/app_theme_mode.dart';
import 'profile_dimens.dart';
import 'profile_strings.dart';

/// «فاتح / داكن / حسب الجهاز» as a three-way segmented control.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key, required this.selected, required this.onSelected});

  final AppThemeMode selected;
  final ValueChanged<AppThemeMode> onSelected;

  static const _options = [
    (AppThemeMode.light, ProfileStrings.themeLight),
    (AppThemeMode.dark, ProfileStrings.themeDark),
    (AppThemeMode.system, ProfileStrings.themeSystem),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final optionRadius = BorderRadius.circular(ProfileDimens.themeOptionRadius);
    return Container(
      padding: const EdgeInsets.all(ProfileDimens.themeTrackPadding),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(ProfileDimens.themeTrackRadius),
      ),
      child: Row(children: [
        for (final (index, (mode, label)) in _options.indexed) ...[
          if (index > 0) const SizedBox(width: ProfileDimens.themeTrackPadding),
          Expanded(
            child: Semantics(
              selected: mode == selected,
              inMutuallyExclusiveGroup: true,
              child: Material(
                color: mode == selected ? c.surface : Colors.transparent,
                borderRadius: optionRadius,
                child: InkWell(
                  borderRadius: optionRadius,
                  onTap: () => onSelected(mode),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: ProfileDimens.themeOptionHeight),
                    child: Center(
                      child: Text(label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ProfileDimens.themeFontSize,
                            fontWeight: mode == selected ? FontWeight.w700 : FontWeight.w500,
                            color: mode == selected ? c.textPrimary : c.textSecondary,
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}