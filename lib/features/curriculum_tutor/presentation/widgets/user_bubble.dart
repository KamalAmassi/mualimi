import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'tutor_sizes.dart';

class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final maxWidth =
        MediaQuery.sizeOf(context).width * TutorSizes.userBubbleMaxWidthFactor;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: c.primary,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(AppSizes.radiusCard),
            topEnd: Radius.circular(AppSizes.radiusCard),
            bottomEnd: Radius.circular(AppSizes.radiusCard),
            bottomStart: Radius.circular(TutorSizes.bubbleTailRadius),
          ),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: TutorSizes.textBody,
                height: 1.7,
                color: c.onPrimary)),
      ),
    );
  }
}
