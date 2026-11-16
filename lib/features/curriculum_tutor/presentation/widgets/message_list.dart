import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/tutor_controller.dart';
import 'answer_bubble.dart';
import 'chat_scroller.dart';
import 'tutor_sizes.dart';
import 'user_bubble.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key, required this.controller});

  final TutorController controller;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final _scroller = ChatScroller();
  late final Worker _follow;

  TutorController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _follow = ever(controller.messages, (_) => _scroller.jumpToEnd());
  }

  @override
  void dispose() {
    _follow.dispose();
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Obx(() {
      final messages = controller.messages.toList();
      return ListView.builder(
        controller: _scroller.controller,
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
