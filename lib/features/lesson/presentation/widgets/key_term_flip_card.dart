import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/key_term.dart';
import 'key_term_card_face.dart';
import 'key_terms_dimens.dart';

/// Turns around the vertical axis whenever the shown card or side changes.
class KeyTermFlipCard extends StatelessWidget {
  const KeyTermFlipCard({
    super.key,
    required this.term,
    required this.position,
    required this.counter,
    required this.showingDefinition,
    required this.onTap,
  });

  final KeyTerm term;
  final int position;
  final String counter;
  final bool showingDefinition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedSwitcher(
        duration: KeyTermsDimens.flipDuration,
        transitionBuilder: _flip,
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topCenter,
          children: [...previous, if (current != null) current],
        ),
        child: KeyTermCardFace(
          key: ValueKey((position, showingDefinition)),
          term: term,
          counter: counter,
          showingDefinition: showingDefinition,
        ),
      ),
    );
  }

  static Widget _flip(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        // Each face is visible only during its half of the turn: the outgoing
        // face turns away first, then the incoming one turns in from the
        // opposite edge, so the card keeps spinning in one direction.
        final turn = (1 - animation.value) * math.pi;
        final hidden = turn > math.pi / 2;
        final outgoing = animation.status == AnimationStatus.reverse;
        return Opacity(
          opacity: hidden ? 0 : 1,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, KeyTermsDimens.flipPerspective)
              ..rotateY(hidden ? 0 : (outgoing ? turn : -turn)),
            child: child,
          ),
        );
      },
    );
  }
}
