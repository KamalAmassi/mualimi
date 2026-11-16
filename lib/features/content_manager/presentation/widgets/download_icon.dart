import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/download_dimens.dart';

/// A stroked 24×24 SVG glyph from [DownloadIcons], tinted with [color].
class DownloadIcon extends StatelessWidget {
  const DownloadIcon(
    this.path, {
    super.key,
    required this.color,
    this.size = DownloadDimens.buttonIconSize,
    this.strokeWidth = DownloadDimens.iconStroke,
  });

  /// SVG path data (`d` attribute), usually a [DownloadIcons] constant.
  final String path;
  final Color color;
  final double size;
  final double strokeWidth;

  String get _svg =>
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
      'fill="none" stroke="#000000" stroke-width="$strokeWidth" '
      'stroke-linecap="round" stroke-linejoin="round">'
      '<path d="$path"/></svg>';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
