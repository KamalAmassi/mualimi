import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Shows [child] in a rounded sheet with a drag handle. Sheets have no routes.
Future<T?> showAppBottomSheet<T>(Widget child, {bool scrollable = true}) {
  return Get.bottomSheet<T>(
    _SheetFrame(child: child),
    isScrollControlled: scrollable,
    backgroundColor: Colors.transparent,
  );
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusSheet)),
      ),
      padding: EdgeInsets.fromLTRB(AppSizes.pagePadding, AppSizes.md, AppSizes.pagePadding,
          AppSizes.pagePadding + MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: AppSizes.sheetHandleWidth,
            height: AppSizes.sheetHandleHeight,
            decoration: BoxDecoration(
              color: c.outlineStrong,
              borderRadius: BorderRadius.circular(AppSizes.radiusChip),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          child,
        ]),
      ),
    );
  }
}
