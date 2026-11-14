import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/tutor_controller.dart';
import 'answer_bubble.dart';
import 'tutor_sizes.dart';
import 'user_bubble.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key, required this.controller});

  final TutorController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final messages = controller.messages.toList();
      return ListView.builder(
        controller: controller.scroll,
        padding: const EdgeInsets.all(AppSizes.lg),
        itemCount: messages.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: Center(
                child: Text(AppStrings.today,
                    style: TextStyle(
                        fontSize: TutorSizes.textSmall,
                        color: c.textSecondary)),
              ),
            );
          }
          final message = messages[i - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: message.isUser
                ? UserBubble(text: message.text)
                : AnswerBubble(
                    key: ValueKey(message.id),
                    message: message,
                    controller: controller,
                  ),
          );
        },
      );
    });
  }
}
