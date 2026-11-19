import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controllers/profile_controller.dart';
import '../widgets/about_sheet.dart';
import '../widgets/change_grade_sheet.dart';
import '../widgets/edit_name_sheet.dart';
import '../widgets/profile_action_pill.dart';
import '../widgets/profile_dimens.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_setting_row.dart';
import '../widgets/profile_strings.dart';
import '../widgets/storage_usage_card.dart';
import '../widgets/theme_mode_selector.dart';

/// Shell tab 3.
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  static const _sectionGap = SizedBox(height: ProfileDimens.sectionGap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final p = controller.profile.value;
          return ListView(children: [
            ProfileHeader(
              initial: controller.initial,
              name: p.name,
              subtitle: controller.headerSubtitle,
              onEditName: () => showEditNameSheet(controller),
            ),
            Padding(
              padding: const EdgeInsets.all(ProfileDimens.pageGutter),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                StorageUsageCard(usage: controller.storage.value),
                _sectionGap,
                ProfileSection(title: ProfileStrings.appearance, boxed: false, children: [
                  ThemeModeSelector(selected: p.themeMode, onSelected: controller.setTheme),
                ]),
                _sectionGap,
                ProfileSection(title: ProfileStrings.study, children: [
                  ProfileSettingRow(
                    icon: LucideIcons.bookOpen,
                    title: ProfileStrings.grade,
                    subtitle: controller.gradeOrdinal,
                    action: ProfileActionPill(
                      label: ProfileStrings.change,
                      onPressed: () => showChangeGradeSheet(controller),
                    ),
                  ),
                  ProfileSettingRow(
                    icon: LucideIcons.aLargeSmall,
                    title: ProfileStrings.fontSize,
                    subtitle: controller.fontScaleLabel,
                    onTap: controller.cycleFontScale,
                  ),
                ]),
                _sectionGap,
                ProfileSection(title: ProfileStrings.downloads, children: [
                  ProfileSettingRow(
                    icon: LucideIcons.archive,
                    title: ProfileStrings.packTitle(controller.gradeOrdinal),
                    subtitle: controller.packSubtitle,
                    action: ProfileActionPill(
                      label: ProfileStrings.checkUpdate,
                      onPressed:
                          controller.checkingUpdate.value ? null : controller.checkForUpdate,
                    ),
                  ),
                ]),
                _sectionGap,
                ProfileSection(title: ProfileStrings.aboutSection, children: [
                  ProfileSettingRow(
                    icon: LucideIcons.info,
                    title: ProfileStrings.about,
                    subtitle: ProfileStrings.aboutSubtitle,
                    onTap: () => showAboutSheet(controller),
                  ),
                ]),
              ]),
            ),
          ]);
        }),
      ),
    );
  }
}
