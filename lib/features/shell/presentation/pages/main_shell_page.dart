import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../subjects/presentation/pages/home_page.dart';
import '../controllers/shell_controller.dart';

/// Three tabs: Subjects · Smart Tutor · Profile. IndexedStack keeps each
/// tab's state while the student switches.
class MainShellPage extends GetView<ShellController> {
  const MainShellPage({super.key});

  static const _items = [
    AppBottomNavItem(label: AppStrings.subjects, icon: LucideIcons.bookOpen),
    AppBottomNavItem(label: AppStrings.smartTutor, icon: LucideIcons.sparkles),
    AppBottomNavItem(label: AppStrings.profile, icon: LucideIcons.user),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(index: controller.index.value, children: const [
            HomePage(),
            PlaceholderPage(title: AppStrings.smartTutor),
            ProfilePage(),
          ])),
      bottomNavigationBar: Obx(() => AppBottomNav(
            items: _items,
            currentIndex: controller.index.value,
            onSelected: controller.select,
          )),
    );
  }
}
