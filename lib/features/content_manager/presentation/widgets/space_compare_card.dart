import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/byte_formatter.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';

/// Card comparing the space the pack needs with the space free on the device.
class SpaceCompareCard extends StatelessWidget {
  const SpaceCompareCard({
    super.key,
    required this.requiredBytes,
    required this.availableBytes,
  });

  final int requiredBytes;
  final int availableBytes;

  /// Share of the required space that is available, in 0..1.
  double get availableFraction =>
      requiredBytes <= 0 ? 1 : (availableBytes / requiredBytes).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(DownloadDimens.cardPadding),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.outline, width: DownloadDimens.cardBorderWidth),
        borderRadius: BorderRadius.circular(DownloadDimens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row(c, DownloadStrings.requiredLabel, requiredBytes, c.textPrimary),
          const SizedBox(height: DownloadDimens.compareGap),
          _row(c, DownloadStrings.availableLabel, availableBytes, c.error),
          const SizedBox(height: DownloadDimens.compareGap),
          _bar(c),
        ],
      ),
    );
  }

  Widget _bar(AppColors c) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DownloadDimens.compareBarRadius),
      child: Container(
        height: DownloadDimens.compareBarHeight,
        color: c.surfaceVariant,
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: availableFraction,
          heightFactor: 1,
          child: ColoredBox(color: c.error),
        ),
      ),
    );
  }

  Widget _row(AppColors c, String label, int bytes, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: DownloadDimens.compareRowFontSize, color: c.textSecondary),
          ),
        ),
        const SizedBox(width: DownloadDimens.compareGap),
        Text(
          ByteFormatter.format(bytes),
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: DownloadDimens.compareRowFontSize,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
