import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'primary_button.dart';

class PlaceholderAction {
  const PlaceholderAction(this.label, this.onTap);
  final String label;
  final VoidCallback? onTap;
}

/// Skeleton screen: title bar, optional status line and a few buttons that
/// exercise the navigation flow. Replaced by the real design later.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    this.status,
    this.actions = const [],
  });

  final String title;
  final String? status;
  final List<PlaceholderAction> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (status != null) ...[
              Text(status!, textAlign: TextAlign.center, style: TextStyle(color: c.textSecondary)),
              const SizedBox(height: AppSizes.xl),
            ],
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSizes.md),
              PrimaryButton(
                label: actions[i].label,
                onPressed: actions[i].onTap,
                outlined: i > 0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
