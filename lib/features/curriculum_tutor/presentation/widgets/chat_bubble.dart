import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.saved = false,
    this.onSave,
    this.onReport,
  });

  final ChatMessage message;
  final bool saved;
  final VoidCallback? onSave;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final user = message.isUser;
    return Align(
      alignment: user ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: user ? c.tint : c.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border: Border.all(color: c.outline),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(message.text, style: TextStyle(color: c.textPrimary)),
          for (final p in message.passages)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Text('(${p.page}) ${p.text}', style: TextStyle(color: c.textBody)),
            ),
          if (message.source != null)
            Text('${AppStrings.sourceLabel}: ${message.source!.page}',
                style: TextStyle(color: c.textSecondary)),
          if (!user && message.text.isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [
              TextButton(
                onPressed: saved ? null : onSave,
                child: const Text(AppStrings.saveAnswer),
              ),
              TextButton(onPressed: onReport, child: const Text(AppStrings.reportAnswer)),
            ]),
        ]),
      ),
    );
  }
}
