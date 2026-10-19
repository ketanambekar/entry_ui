import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_button_theme.dart';
import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_fonts.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primary50,
      onPrimaryContainer: AppColors.primary600,
      secondary: AppColors.accent,
      onSecondary: AppColors.primary900,
      secondaryContainer: AppColors.accent50,
      onSecondaryContainer: AppColors.accent600,
      tertiary: AppColors.primary900,
      onTertiary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.error50,
      onErrorContainer: AppColors.error600,
      surface: AppColors.surface,
      onSurface: AppColors.grey800,
      onSurfaceVariant: AppColors.grey500,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.grey25,
      surfaceContainer: AppColors.grey25,
      surfaceContainerHigh: AppColors.grey50,
      surfaceContainerHighest: AppColors.grey100,
      outline: AppColors.grey200,
      outlineVariant: AppColors.grey100,
    ),
    scaffoldBackground: AppColors.grey25,
    divider: AppColors.grey50,
    buttons: AppButtonTheme.light,
  );

  static ThemeData get dark => _build(
    ColorScheme.fromSeed(
      seedColor: AppDarkColors.primary,
      brightness: Brightness.dark,
      primary: AppDarkColors.primary,
      onPrimary: AppDarkColors.primary900,
      primaryContainer: AppDarkColors.primary50,
      onPrimaryContainer: AppDarkColors.primary600,
      secondary: AppDarkColors.accent,
      onSecondary: AppDarkColors.primary900,
      secondaryContainer: AppDarkColors.accent50,
      onSecondaryContainer: AppDarkColors.accent600,
      tertiary: AppDarkColors.primary800,
      onTertiary: AppDarkColors.primary900,
      error: AppDarkColors.error,
      onError: AppDarkColors.primary900,
      errorContainer: AppDarkColors.error50,
      onErrorContainer: AppDarkColors.error600,
      surface: AppDarkColors.surface,
      onSurface: AppDarkColors.grey800,
      onSurfaceVariant: AppDarkColors.grey500,
      surfaceContainerLowest: AppDarkColors.grey25,
      surfaceContainerLow: AppDarkColors.surface,
      surfaceContainer: AppDarkColors.surface,
      surfaceContainerHigh: AppDarkColors.grey50,
      surfaceContainerHighest: AppDarkColors.grey100,
      outline: AppDarkColors.grey200,
      outlineVariant: AppDarkColors.grey100,
    ),
    scaffoldBackground: AppDarkColors.grey25,
    divider: AppDarkColors.grey50,
    buttons: AppButtonTheme.dark,
  );

  static ThemeData _build(
    ColorScheme scheme, {
    required Color scaffoldBackground,
    required Color divider,
    required AppButtonTheme buttons,
  }) {
    // `fontFamily` makes Manrope the default for every text style. The type
    // scale is merged afterwards so Banana Grotesk display styles keep their
    // font (ThemeData's fontFamily would otherwise override them).
    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: AppFonts.manrope,
      scaffoldBackgroundColor: scaffoldBackground,
      dividerColor: divider,
      extensions: [buttons],
    );
    return base.copyWith(
      textTheme: base.textTheme
          .merge(AppTextStyles.textTheme)
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      primaryTextTheme: base.primaryTextTheme.merge(AppTextStyles.textTheme),
    );
  }
}
