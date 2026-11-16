import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/tutor_engine_service.dart';
import '../../domain/entities/chat_message.dart';
import '../controllers/tutor_controller.dart';
import 'answer_card.dart';
import 'notice_card.dart';
import 'pending_badge.dart';
import 'passage_card.dart';
import 'report_sheet.dart';
import 'tutor_sizes.dart';

/// The tutor's side of an exchange; its look follows [ChatMessage.state].
class AnswerBubble extends StatelessWidget {
  const AnswerBubble(
      {super.key, required this.message, required this.controller});

  final ChatMessage message;
  final TutorController controller;

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.sizeOf(context).width * TutorSizes.answerWidthFactor;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SizedBox(width: width, child: _content()),
    );
  }

  Widget _content() {
    switch (message.state) {
      case AnswerState.streaming:
      case AnswerState.answered:
        return Obx(() => AnswerCard(
              message: message,
              saved: controller.savedIds.contains(message.id),
              onFollowUp: (f) => controller.followUp(message, f),
              onSave: () => controller.save(message),
              onReport: () =>
                  showReportSheet(message, lessonId: message.source?.lessonId),
              onOpenSource: () {
                final s = message.source;
                if (s != null) controller.openInPack(s.lessonId, s.pdfPage);
              },
            ));
      case AnswerState.outOfScope:
      case AnswerState.unsupported:
        return const NoticeCard(
          icon: LucideIcons.search,
          title: AppStrings.outOfScopeTitle,
          body: AppStrings.outOfScopeBody,
        );
      case AnswerState.needsInternet:
        return const NoticeCard(
          icon: LucideIcons.wifiOff,
          title: AppStrings.needsInternetTitle,
          body: AppStrings.needsInternetBody,
          warning: false,
        );
      case AnswerState.failed:
        return const NoticeCard(
          icon: LucideIcons.circleAlert,
          title: AppStrings.answerFailed,
          body: AppStrings.needsInternetBody,
        );
      case AnswerState.limitReached:
        return _withPassages(
          const NoticeCard(
            icon: LucideIcons.clock,
            title: AppStrings.dailyLimitTitle,
            body: AppStrings.dailyLimitExplanation,
            warning: false,
          ),
        );
      case AnswerState.offline:
        return _withPassages(Obx(() {
          final configured =
              controller.engineState.value != TutorEngineState.notConfigured;
          return NoticeCard(
            icon: LucideIcons.wifiOff,
            title: configured
                ? AppStrings.offlineTitle
                : AppStrings.notConfiguredTitle,
            body: configured
                ? AppStrings.offlineExplanation
                : AppStrings.notConfiguredExplanation,
            warning: false,
          );
        }));
    }
  }

  Widget _withPassages(Widget notice) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      notice,
      if (message.isPending)
        PendingBadge(onDelete: () => controller.deletePending(message)),
      if (message.passages.isNotEmpty) ...[
        const _PassagesTitle(),
        for (final p in message.passages)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: PassageCard(
              passage: p,
              onOpen: () => controller.openInPack(p.lessonId, p.pdfPage),
            ),
          ),
      ],
    ]);
  }
}

class _PassagesTitle extends StatelessWidget {
  const _PassagesTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(AppStrings.nearestPassages,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}
