import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/key_term.dart';
import 'key_terms_dimens.dart';
import 'key_terms_strings.dart';

/// One side of the flip card: the term alone, or the term over its definition.
class KeyTermCardFace extends StatelessWidget {
  const KeyTermCardFace({
    super.key,
    required this.term,
    required this.counter,
    required this.showingDefinition,
  });

  final KeyTerm term;
  final String counter;
  final bool showingDefinition;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final meta = TextStyle(fontSize: KeyTermsDimens.cardMetaFontSize, color: c.onPrimaryMuted);
    return Container(
      constraints: const BoxConstraints(minHeight: KeyTermsDimens.cardMinHeight),
      padding: const EdgeInsets.all(KeyTermsDimens.cardPadding),
      decoration: BoxDecoration(
        color: c.primary,
        borderRadius: BorderRadius.circular(KeyTermsDimens.cardRadius),
      ),
      child: IntrinsicHeight(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSizes.sm,
            children: [
              Text(counter, style: meta),
              Text(KeyTermsStrings.flipHint, style: meta),
            ],
          ),
          const SizedBox(height: KeyTermsDimens.cardGap),
          Expanded(child: Center(child: showingDefinition ? _back(c) : _front(c))),
        ]),
      ),
    );
  }

  Widget _front(AppColors c) => Text(
        term.term,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: KeyTermsDimens.cardTermFontSize,
          fontWeight: FontWeight.w700,
          color: c.onPrimary,
        ),
      );

  Widget _back(AppColors c) => Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          term.term,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: KeyTermsDimens.backTermFontSize,
            fontWeight: FontWeight.w700,
            color: c.onPrimaryMuted,
          ),
        ),
        const SizedBox(height: KeyTermsDimens.cardGap),
        Text(
          term.definition,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: KeyTermsDimens.backDefinitionFontSize,
            fontWeight: FontWeight.w500,
            height: KeyTermsDimens.backDefinitionLineHeight,
            color: c.onPrimary,
          ),
        ),
      ]);
}
