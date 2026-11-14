import 'package:flutter/widgets.dart';

/// Keeps the conversation scrolled to the newest message.
class ChatScroller {
  final controller = ScrollController();

  void jumpToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  void dispose() => controller.dispose();
}
