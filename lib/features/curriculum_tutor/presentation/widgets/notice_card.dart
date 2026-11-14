import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'tutor_sizes.dart';

/// Tinted explanation card used for out-of-scope, offline and limit states.
class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.warning = true,
  });

  final IconData icon;
  final String title;
  final String body;

  /// Amber card when true, blue information card when false.
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final background = warning ? c.warningContainer : c.infoContainer;
    final titleColor = warning ? c.onWarningContainer : c.onInfoContainer;
    final bodyColor = warning ? c.onWarningContainerMuted : c.onInfoContainer;
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: TutorSizes.noticeIcon,
          height: TutorSizes.noticeIcon,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(TutorSizes.noticeIconRadius),
          ),
          child: Icon(icon,
              size: AppSizes.iconMd, color: warning ? c.warning : c.info),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    fontSize: TutorSizes.textBody,
                    fontWeight: FontWeight.w700,
                    color: titleColor)),
            const SizedBox(height: AppSizes.xs),
            Text(body,
                style:
                    TextStyle(fontSize: 13.5, height: 1.7, color: bodyColor)),
          ]),
        ),
      ]),
    );
  }
}
