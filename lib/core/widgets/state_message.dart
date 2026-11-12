import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'primary_button.dart';

/// Empty / error / info state with an optional action.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: AppSizes.iconLg, color: c.primary),
          const SizedBox(height: AppSizes.lg),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary)),
          if (message != null) ...[
            const SizedBox(height: AppSizes.sm),
            Text(message!,
                textAlign: TextAlign.center, style: TextStyle(color: c.textSecondary)),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: AppSizes.xl),
            PrimaryButton(label: actionLabel!, onPressed: onAction),
          ],
        ]),
      ),
    );
  }
}
