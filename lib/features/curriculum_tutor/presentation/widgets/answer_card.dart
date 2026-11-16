import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/follow_up.dart';
import 'answer_actions.dart';
import 'answer_text.dart';
import 'source_line.dart';
import 'tutor_sizes.dart';

/// A white answer bubble: streamed or finished text, source, actions.
class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.message,
    required this.saved,
    required this.onFollowUp,
    required this.onSave,
    required this.onReport,
    required this.onOpenSource,
  });

  final ChatMessage message;
  final bool saved;
  final ValueChanged<FollowUp> onFollowUp;
  final VoidCallback onSave;
  final VoidCallback onReport;
  final VoidCallback onOpenSource;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final streaming = message.state == AnswerState.streaming;
    final source = message.source;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.outline),
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(AppSizes.radiusCard),
          topEnd: Radius.circular(AppSizes.radiusCard),
          bottomStart: Radius.circular(AppSizes.radiusCard),
          bottomEnd: Radius.circular(TutorSizes.bubbleTailRadius),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (message.fromBank) _PackLabel(color: c.primaryText),
        AnswerText(text: message.text, cursor: streaming),
        if (streaming)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: Row(children: [
              Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: c.primaryText, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(AppStrings.writingNow,
                  style: TextStyle(
                      fontSize: TutorSizes.textSmall, color: c.textSecondary)),
            ]),
          ),
        if (!streaming) ...[
          if (message.stopped)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.sm),
              child: Text(AppStrings.answerStopped,
                  style: TextStyle(
                      fontSize: TutorSizes.textSmall, color: c.textSecondary)),
            ),
          if (source != null) ...[
            const SizedBox(height: AppSizes.md),
            SourceLine(source: source, onOpen: onOpenSource),
          ],
          const SizedBox(height: AppSizes.md),
          AnswerActions(
            showFollowUps: message.canFollowUp,
            saved: saved,
            onFollowUp: onFollowUp,
            onSave: onSave,
            onReport: onReport,
          ),
        ],
      ]),
    );
  }
}

class _PackLabel extends StatelessWidget {
  const _PackLabel({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Text(AppStrings.fromPack,
          style: TextStyle(
              fontSize: TutorSizes.textSmall,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }
}
