// lib/core/constants/app_colors.dart
// نظام الألوان المركزي لتطبيق معلّمي — مصدر واحد للوضعين الفاتح والداكن.
// مولّد من نفس القيم المستخدمة في ملف التصميم؛ لا تستخدم Color(...) ثابتاً في الواجهات.
// الاستخدام: context.colors.primary  أو  Theme.of(context).extension<AppColors>()!
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color onPrimary;
  final Color onPrimaryMuted;
  final Color primaryText;
  final Color primaryStrong;
  final Color secondary;
  final Color accent;
  final Color onAccent;
  final Color navIndicator;
  final Color tint;
  final Color tintSoft;
  final Color onTint;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color outline;
  final Color outlineStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textBody;
  final Color hero;
  final Color onHero;
  final Color onHeroMuted;
  final Color heroChip;
  final Color heroTrack;
  final Color heroDeco;
  final Color heroDecoDeep;
  final Color heroRing;
  final Color heroHighlight;
  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color onWarningContainerMuted;
  final Color warningOutline;
  final Color error;
  final Color errorContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color videoPlayer;
  final Color videoPlayerOverlay;
  final Color onVideoPlayer;
  final Color storageSegment;
  final Color shadowSoft;
  final Color shadowStrong;
  final Color subjectScience;
  final Color subjectScienceHeader;
  final Color subjectArabic;
  final Color subjectEnglish;
  final Color subjectMath;
  final Color subjectIslamic;
  final Color subjectHistory;
  final Color subjectGeography;
  final Color subjectTech;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.onPrimaryMuted,
    required this.primaryText,
    required this.primaryStrong,
    required this.secondary,
    required this.accent,
    required this.onAccent,
    required this.navIndicator,
    required this.tint,
    required this.tintSoft,
    required this.onTint,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.outline,
    required this.outlineStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textBody,
    required this.hero,
    required this.onHero,
    required this.onHeroMuted,
    required this.heroChip,
    required this.heroTrack,
    required this.heroDeco,
    required this.heroDecoDeep,
    required this.heroRing,
    required this.heroHighlight,
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.onWarningContainerMuted,
    required this.warningOutline,
    required this.error,
    required this.errorContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.videoPlayer,
    required this.videoPlayerOverlay,
    required this.onVideoPlayer,
    required this.storageSegment,
    required this.shadowSoft,
    required this.shadowStrong,
    required this.subjectScience,
    required this.subjectScienceHeader,
    required this.subjectArabic,
    required this.subjectEnglish,
    required this.subjectMath,
    required this.subjectIslamic,
    required this.subjectHistory,
    required this.subjectGeography,
    required this.subjectTech,
  });

  static const light = AppColors(
    primary: Color(0xFF6C4CE3),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryMuted: Color(0xFFF3F0FF),
    primaryText: Color(0xFF5B3BD6),
    primaryStrong: Color(0xFF4A2FB8),
    secondary: Color(0xFF9B87F5),
    accent: Color(0xFFDCD6FF),
    onAccent: Color(0xFF4A2FB8),
    navIndicator: Color(0xFFDCD6FF),
    tint: Color(0xFFECE8FF),
    tintSoft: Color(0xFFF3F0FF),
    onTint: Color(0xFF4A2FB8),
    background: Color(0xFFF7F6FF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEDEAFA),
    outline: Color(0xFFE5E1F5),
    outlineStrong: Color(0xFFC6BEEA),
    textPrimary: Color(0xFF252044),
    textSecondary: Color(0xFF605B7D),
    textBody: Color(0xFF46405F),
    hero: Color(0xFF6C4CE3),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFECE8FF),
    heroChip: Color(0x402A1A7A),
    heroTrack: Color(0x38FFFFFF),
    heroDeco: Color(0xFF7A5CEA),
    heroDecoDeep: Color(0xFF5E3FD6),
    heroRing: Color(0xFFDCD6FF),
    heroHighlight: Color(0xFFDCD6FF),
    success: Color(0xFF1A7347),
    successContainer: Color(0xFFE4F5EB),
    onSuccessContainer: Color(0xFF145C39),
    warning: Color(0xFFA55F00),
    warningContainer: Color(0xFFFFF4DD),
    onWarningContainer: Color(0xFF5E3B00),
    onWarningContainerMuted: Color(0xFF674A1A),
    warningOutline: Color(0xFFE6C485),
    error: Color(0xFFC62828),
    errorContainer: Color(0xFFFDECEC),
    info: Color(0xFF1F6FB5),
    infoContainer: Color(0xFFE5F0FB),
    onInfoContainer: Color(0xFF15528A),
    videoPlayer: Color(0xFF1E1A3A),
    videoPlayerOverlay: Color(0xFF3B2F80),
    onVideoPlayer: Color(0xFFFFFFFF),
    storageSegment: Color(0xFFDCD6FF),
    shadowSoft: Color(0x1A252044),
    shadowStrong: Color(0x40252044),
    subjectScience: Color(0xFF00796B),
    subjectScienceHeader: Color(0xFF6C4CE3),
    subjectArabic: Color(0xFF2E7D32),
    subjectEnglish: Color(0xFFAD1457),
    subjectMath: Color(0xFF1565C0),
    subjectIslamic: Color(0xFF5E7A1F),
    subjectHistory: Color(0xFF7A5A4E),
    subjectGeography: Color(0xFFB35A12),
    subjectTech: Color(0xFF455A64),
  );

  static const dark = AppColors(
    primary: Color(0xFF9B87F5),
    onPrimary: Color(0xFF17152A),
    onPrimaryMuted: Color(0xFF2E2556),
    primaryText: Color(0xFFB6A7FF),
    primaryStrong: Color(0xFFDCD6FF),
    secondary: Color(0xFFB6A7FF),
    accent: Color(0xFFDCD6FF),
    onAccent: Color(0xFF2E2556),
    navIndicator: Color(0xFF3A3266),
    tint: Color(0xFF2F2856),
    tintSoft: Color(0xFF2A2548),
    onTint: Color(0xFFD6CEFF),
    background: Color(0xFF17152A),
    surface: Color(0xFF24213B),
    surfaceVariant: Color(0xFF2E2A4A),
    outline: Color(0xFF36314F),
    outlineStrong: Color(0xFF4D4670),
    textPrimary: Color(0xFFF5F3FF),
    textSecondary: Color(0xFFB9B2D0),
    textBody: Color(0xFFD6D0E8),
    hero: Color(0xFF2B2552),
    onHero: Color(0xFFF5F3FF),
    onHeroMuted: Color(0xFFC9C1E6),
    heroChip: Color(0x1AFFFFFF),
    heroTrack: Color(0x26FFFFFF),
    heroDeco: Color(0xFF342D63),
    heroDecoDeep: Color(0xFF231E45),
    heroRing: Color(0xFF9B87F5),
    heroHighlight: Color(0xFFB6A7FF),
    success: Color(0xFF5BC48A),
    successContainer: Color(0xFF183A2A),
    onSuccessContainer: Color(0xFFA9E8C5),
    warning: Color(0xFFF0B54A),
    warningContainer: Color(0xFF3A2E14),
    onWarningContainer: Color(0xFFF7DCA3),
    onWarningContainerMuted: Color(0xFFE6CD9A),
    warningOutline: Color(0xFF6B5422),
    error: Color(0xFFFF8A80),
    errorContainer: Color(0xFF3D1E26),
    info: Color(0xFF74B4F2),
    infoContainer: Color(0xFF1A2E45),
    onInfoContainer: Color(0xFFB2D5F8),
    videoPlayer: Color(0xFF0F0D1E),
    videoPlayerOverlay: Color(0xFF2B2552),
    onVideoPlayer: Color(0xFFFFFFFF),
    storageSegment: Color(0xFF5E528F),
    shadowSoft: Color(0x33000000),
    shadowStrong: Color(0x66000000),
    subjectScience: Color(0xFF4DB6AC),
    subjectScienceHeader: Color(0xFF2B2552),
    subjectArabic: Color(0xFF7BC67E),
    subjectEnglish: Color(0xFFF48FB1),
    subjectMath: Color(0xFF7FB2F0),
    subjectIslamic: Color(0xFFA8C46A),
    subjectHistory: Color(0xFFC9A497),
    subjectGeography: Color(0xFFF0A35E),
    subjectTech: Color(0xFF9FB3BD),
  );

  @override
  AppColors copyWith() => this; // القيم ثابتة لكل وضع

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onPrimaryMuted: Color.lerp(onPrimaryMuted, other.onPrimaryMuted, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      primaryStrong: Color.lerp(primaryStrong, other.primaryStrong, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      navIndicator: Color.lerp(navIndicator, other.navIndicator, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
      tintSoft: Color.lerp(tintSoft, other.tintSoft, t)!,
      onTint: Color.lerp(onTint, other.onTint, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineStrong: Color.lerp(outlineStrong, other.outlineStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textBody: Color.lerp(textBody, other.textBody, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
      onHeroMuted: Color.lerp(onHeroMuted, other.onHeroMuted, t)!,
      heroChip: Color.lerp(heroChip, other.heroChip, t)!,
      heroTrack: Color.lerp(heroTrack, other.heroTrack, t)!,
      heroDeco: Color.lerp(heroDeco, other.heroDeco, t)!,
      heroDecoDeep: Color.lerp(heroDecoDeep, other.heroDecoDeep, t)!,
      heroRing: Color.lerp(heroRing, other.heroRing, t)!,
      heroHighlight: Color.lerp(heroHighlight, other.heroHighlight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      onWarningContainerMuted: Color.lerp(onWarningContainerMuted, other.onWarningContainerMuted, t)!,
      warningOutline: Color.lerp(warningOutline, other.warningOutline, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      videoPlayer: Color.lerp(videoPlayer, other.videoPlayer, t)!,
      videoPlayerOverlay: Color.lerp(videoPlayerOverlay, other.videoPlayerOverlay, t)!,
      onVideoPlayer: Color.lerp(onVideoPlayer, other.onVideoPlayer, t)!,
      storageSegment: Color.lerp(storageSegment, other.storageSegment, t)!,
      shadowSoft: Color.lerp(shadowSoft, other.shadowSoft, t)!,
      shadowStrong: Color.lerp(shadowStrong, other.shadowStrong, t)!,
      subjectScience: Color.lerp(subjectScience, other.subjectScience, t)!,
      subjectScienceHeader: Color.lerp(subjectScienceHeader, other.subjectScienceHeader, t)!,
      subjectArabic: Color.lerp(subjectArabic, other.subjectArabic, t)!,
      subjectEnglish: Color.lerp(subjectEnglish, other.subjectEnglish, t)!,
      subjectMath: Color.lerp(subjectMath, other.subjectMath, t)!,
      subjectIslamic: Color.lerp(subjectIslamic, other.subjectIslamic, t)!,
      subjectHistory: Color.lerp(subjectHistory, other.subjectHistory, t)!,
      subjectGeography: Color.lerp(subjectGeography, other.subjectGeography, t)!,
      subjectTech: Color.lerp(subjectTech, other.subjectTech, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
