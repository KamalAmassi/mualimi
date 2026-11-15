import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../constants/download_dimens.dart';
import '../constants/download_strings.dart';
import 'download_icon.dart';
import 'download_icons.dart';

/// Frame shared by the download screens: header (back + title), a
/// scrollable body, and a footer pinned to the bottom when content is short.
class DownloadScaffold extends StatelessWidget {
  const DownloadScaffold({
    super.key,
    required this.title,
    required this.children,
    this.footer = const [],
    this.onBack,
    this.padding = const EdgeInsets.all(DownloadDimens.bodyPadding),
    this.gap = DownloadDimens.bodyGap,
  });

  final String title;
  final List<Widget> children;

  /// Footer items (step bars, button), spaced by [DownloadDimens.footerGap].
  final List<Widget> footer;

  /// Back button tap; the button is hidden when null.
  final VoidCallback? onBack;
  final EdgeInsetsGeometry padding;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(c),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ..._spaced(children, gap),
                          const Spacer(),
                          if (footer.isNotEmpty) ...[
                            SizedBox(height: gap),
                            ..._spaced(footer, DownloadDimens.footerGap),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(AppColors c) {
    final back = onBack;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        DownloadDimens.headerPaddingHorizontal,
        DownloadDimens.headerPaddingTop,
        DownloadDimens.headerPaddingHorizontal,
        DownloadDimens.headerPaddingBottom,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.outline, width: DownloadDimens.headerBorderWidth)),
      ),
      child: Row(
        children: [
          if (back != null) ...[
            Semantics(
              button: true,
              label: DownloadStrings.back,
              child: InkWell(
                onTap: back,
                borderRadius: BorderRadius.circular(DownloadDimens.backButtonRadius),
                child: SizedBox.square(
                  dimension: DownloadDimens.backButtonSize,
                  child: Center(
                    child: DownloadIcon(DownloadIcons.chevron, color: c.textPrimary, size: DownloadDimens.backIconSize),
                  ),
                ),
              ),
            ),
            const SizedBox(width: DownloadDimens.headerGap),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: DownloadDimens.titleFontSize,
                fontWeight: FontWeight.w700,
                height: DownloadDimens.titleLineHeight,
                color: c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> _spaced(List<Widget> items, double gap) => [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          items[i],
        ],
      ];
}
