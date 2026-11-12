// lib/core/theme/app_theme.dart
// ColorScheme و ThemeData للوضعين، مبنية فقط من AppColors.
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness b) {
    final scheme = ColorScheme(
      brightness: b,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.tint,
      onPrimaryContainer: c.onTint,
      secondary: c.secondary,
      onSecondary: c.onPrimary,
      secondaryContainer: c.accent,
      onSecondaryContainer: c.onAccent,
      tertiary: c.info,
      onTertiary: c.onPrimary,
      error: c.error,
      onError: c.onPrimary,
      errorContainer: c.errorContainer,
      onErrorContainer: c.error,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerHighest: c.surfaceVariant,
      outline: c.outlineStrong,
      outlineVariant: c.outline,
      shadow: c.shadowStrong,
    );
    final radius = BorderRadius.circular(16);
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      fontFamily: 'IBMPlexSansArabic',
      scaffoldBackgroundColor: c.background,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: c.outline)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          side: BorderSide(color: c.outline, width: 1.5),
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: c.primaryText)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: TextStyle(color: c.textSecondary),
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: c.outline)),
        enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: c.outline)),
        focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: c.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: c.error)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.tint,
        selectedColor: c.primary,
        labelStyle: TextStyle(color: c.onTint, fontWeight: FontWeight.w600),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.navIndicator,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? c.primary : c.textSecondary)),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontSize: 12,
            fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: s.contains(WidgetState.selected) ? c.primary : c.textSecondary)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primary, linearTrackColor: c.surfaceVariant),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: c.primary, foregroundColor: c.onPrimary),
      dividerTheme: DividerThemeData(color: c.outline, thickness: 1),
      iconTheme: IconThemeData(color: c.textPrimary),
      snackBarTheme: SnackBarThemeData(backgroundColor: c.textPrimary, contentTextStyle: TextStyle(color: c.background)),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: c.surface, surfaceTintColor: Colors.transparent),
    );
  }
}

// في main.dart (GetX):
// GetMaterialApp(
//   theme: AppTheme.light,
//   darkTheme: AppTheme.dark,
//   themeMode: ThemeMode.system, // أو من GetStorage لاختيار الطالب
//   locale: const Locale('ar'),
// );
