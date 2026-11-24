import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'section_body_dimens.dart';

/// A pack image with its caption. When the file is missing or cannot be
/// decoded, only the caption is shown, and nothing when it has none.
class SectionImage extends StatelessWidget {
  const SectionImage({
    super.key,
    required this.path,
    required this.caption,
    required this.fontScale,
  });

  final String? path;
  final String caption;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final captionText = caption.isEmpty
        ? null
        : Text(
            caption,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SectionBodyDimens.captionSize * fontScale,
              color: context.colors.textSecondary,
            ),
          );
    final file = path;
    if (file == null) return captionText ?? const SizedBox.shrink();
    return LayoutBuilder(builder: (context, constraints) {
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      return Image.file(
        File(file),
        cacheWidth: (constraints.maxWidth * pixelRatio).round(),
        frameBuilder: (context, image, frame, _) => frame == null
            ? const SizedBox.shrink()
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(SectionBodyDimens.imageRadius),
                  child: image,
                ),
                if (captionText != null) ...[
                  const SizedBox(height: SectionBodyDimens.imageCaptionGap),
                  captionText,
                ],
              ]),
        errorBuilder: (context, error, stackTrace) => captionText ?? const SizedBox.shrink(),
      );
    });
  }
}
