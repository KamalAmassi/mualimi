import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/byte_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/storage_usage.dart';
import 'profile_dimens.dart';
import 'profile_strings.dart';
import 'storage_legend_item.dart';

/// Pack and PDF bytes as a split bar. Empty until the sizes are measured.
class StorageUsageCard extends StatelessWidget {
  const StorageUsageCard({super.key, required this.usage});

  final StorageUsage? usage;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final usage = this.usage;
    final packColor = c.storageSegment;
    final pdfColor = c.outlineStrong;
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
            children: [
          Expanded(
            child: Text(ProfileStrings.storageTitle,
                style: TextStyle(
                    fontSize: ProfileDimens.storageTitleFontSize,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary)),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(usage == null ? '' : ByteFormatter.format(usage.totalBytes),
              style: TextStyle(
                  fontSize: ProfileDimens.storageTotalFontSize, color: c.textSecondary)),
        ]),
        const SizedBox(height: ProfileDimens.storageGap),
        ClipRRect(
          borderRadius: BorderRadius.circular(ProfileDimens.barRadius),
          child: Container(
            height: ProfileDimens.barHeight,
            color: c.surfaceVariant,
            child: usage == null || usage.totalBytes == 0
                ? null
                : Row(children: [
                    if (usage.packBytes > 0)
                      Expanded(flex: usage.packBytes, child: ColoredBox(color: packColor)),
                    if (usage.packBytes > 0 && usage.pdfBytes > 0)
                      const SizedBox(width: ProfileDimens.barGap),
                    if (usage.pdfBytes > 0)
                      Expanded(flex: usage.pdfBytes, child: ColoredBox(color: pdfColor)),
                  ]),
          ),
        ),
        const SizedBox(height: ProfileDimens.storageGap),
        Row(children: [
          Expanded(child: StorageLegendItem(color: packColor, label: ProfileStrings.packSegment)),
          const SizedBox(width: AppSizes.sm),
          Expanded(child: StorageLegendItem(color: pdfColor, label: ProfileStrings.pdfSegment)),
        ]),
      ]),
    );
  }
}