import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding, this.color});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppSizes.radiusCard);
    return Material(
      color: color ?? c.surface,
      shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: c.outline)),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(padding: padding ?? const EdgeInsets.all(AppSizes.lg), child: child),
      ),
    );
  }
}
