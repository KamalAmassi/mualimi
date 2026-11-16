import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'tutor_sizes.dart';

class Composer extends StatelessWidget {
  const Composer({
    super.key,
    required this.input,
    required this.enabled,
    required this.hint,
    required this.onSend,
  });

  final TextEditingController input;
  final bool enabled;
  final String hint;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(TutorSizes.composerHeight / 2);
    OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: radius, borderSide: BorderSide(color: color));
    return Row(children: [
      Expanded(
        child: SizedBox(
          height: TutorSizes.composerHeight,
          child: TextField(
            controller: input,
            enabled: enabled,
            onSubmitted: (_) => onSend(),
            style: TextStyle(fontSize: 14, color: c.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: c.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              border: border(c.outline),
              enabledBorder: border(c.outline),
              disabledBorder: border(c.outline),
              focusedBorder: border(c.primary),
            ),
          ),
        ),
      ),
      const SizedBox(width: AppSizes.sm),
      Material(
        color: enabled ? c.primary : c.secondary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onSend : null,
          child: SizedBox(
            width: TutorSizes.composerHeight,
            height: TutorSizes.composerHeight,
            child: Icon(LucideIcons.arrowLeft,
                color: c.onPrimary, semanticLabel: AppStrings.send),
          ),
        ),
      ),
    ]);
  }
}
