import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_fonts.dart';

/// Design-system type scale. Base styles are Regular; use the weight
/// getters for variants, e.g. `AppTextStyles.displayL.semiBold`.
abstract final class AppTextStyles {
  // Display — Banana Grotesk.
  static final displayL = _style(AppFonts.bananaGrotesk, 32, 1.2);
  static final displayM = _style(AppFonts.bananaGrotesk, 28, 1.2);
  static final displayS = _style(AppFonts.bananaGrotesk, 24, 1.2);
  static final displayT = _style(AppFonts.bananaGrotesk, 22, 1.2);

  // Subtitle.
  static final subtitleL = _style(AppFonts.bananaGrotesk, 20, 1.3);
  static final subtitleM = _style(AppFonts.manrope, 18, 1.3);
  static final subtitleS = _style(AppFonts.manrope, 16, 1.4);
  static final subtitleXS = _style(AppFonts.manrope, 15, 1.4);

  // Body — Manrope.
  static final bodyL = _style(AppFonts.manrope, 14, 1.4);
  static final bodyM = _style(AppFonts.manrope, 13, 1.3);
  static final bodyS = _style(AppFonts.manrope, 12, 1.4);
  static final bodyT = _style(AppFonts.manrope, 11, 1.4);

  // CAPS — uppercase the string (`.toUpperCase()`); TextStyle has no text-transform.
  static final caps = _style(AppFonts.manrope, 12, 1.4);
  static final capsT = _style(AppFonts.manrope, 11, 1.4);

  static TextStyle _style(String family, double size, double height) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        height: height,
        fontWeight: FontWeight.w400,
        leadingDistribution: TextLeadingDistribution.even,
      );

  /// Maps the scale onto Material's [TextTheme] for built-in widgets.
  static final textTheme = TextTheme(
    displayLarge: displayL,
    displayMedium: displayM,
    displaySmall: displayS,
    headlineLarge: displayT,
    headlineMedium: subtitleL,
    headlineSmall: subtitleM,
    titleLarge: subtitleM,
    titleMedium: subtitleS,
    titleSmall: bodyL,
    bodyLarge: subtitleS,
    bodyMedium: bodyL,
    bodySmall: bodyS,
    labelLarge: bodyL,
    labelMedium: bodyS,
    labelSmall: bodyT,
  );
}

extension AppTextStyleWeights on TextStyle {
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
}
