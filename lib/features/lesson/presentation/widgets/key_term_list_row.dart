import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/key_term.dart';
import 'key_terms_dimens.dart';

/// A row of the "all terms" list; the divider above it is drawn unless [first].
class KeyTermListRow extends StatelessWidget {
  const KeyTermListRow({
    super.key,
    required this.term,
    required this.first,
    required this.onTap,
  });

  final KeyTerm term;
  final bool first;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (!first)
        Divider(
            height: KeyTermsDimens.listBorder,
            thickness: KeyTermsDimens.listBorder,
            color: c.outline),
      Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: KeyTermsDimens.rowVerticalPadding,
              horizontal: KeyTermsDimens.rowHorizontalPadding,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(
                term.term,
                style: TextStyle(
                  fontSize: KeyTermsDimens.rowTermFontSize,
                  fontWeight: FontWeight.w700,
                  color: c.primaryText,
                ),
              ),
              Text(
                term.definition,
                style: TextStyle(
                  fontSize: KeyTermsDimens.rowDefinitionFontSize,
                  height: KeyTermsDimens.rowDefinitionLineHeight,
                  color: c.textBody,
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}
