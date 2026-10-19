import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';

/// Colours for one button variant across its interaction states.
/// A null border means the variant has no outline.
@immutable
class AppButtonColors {
  const AppButtonColors({
    required this.background,
    required this.foreground,
    required this.pressedBackground,
    required this.pressedForeground,
    required this.disabledBackground,
    required this.disabledForeground,
    this.border,
    this.pressedBorder,
    this.disabledBorder,
  });

  final Color background;
  final Color foreground;
  final Color? border;
  final Color pressedBackground;
  final Color pressedForeground;
  final Color? pressedBorder;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color? disabledBorder;

  static AppButtonColors lerp(AppButtonColors a, AppButtonColors b, double t) {
    return AppButtonColors(
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      border: Color.lerp(a.border, b.border, t),
      pressedBackground: Color.lerp(
        a.pressedBackground,
        b.pressedBackground,
        t,
      )!,
      pressedForeground: Color.lerp(
        a.pressedForeground,
        b.pressedForeground,
        t,
      )!,
      pressedBorder: Color.lerp(a.pressedBorder, b.pressedBorder, t),
      disabledBackground: Color.lerp(
        a.disabledBackground,
        b.disabledBackground,
        t,
      )!,
      disabledForeground: Color.lerp(
        a.disabledForeground,
        b.disabledForeground,
        t,
      )!,
      disabledBorder: Color.lerp(a.disabledBorder, b.disabledBorder, t),
    );
  }
}

/// Button colours for every variant, registered on [ThemeData.extensions]
/// so they switch automatically between light and dark mode.
@immutable
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  const AppButtonTheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.destructive,
    required this.link,
  });

  final AppButtonColors primary;
  final AppButtonColors secondary;
  final AppButtonColors tertiary;
  final AppButtonColors destructive;
  final AppButtonColors link;

  static AppButtonTheme of(BuildContext context) =>
      Theme.of(context).extension<AppButtonTheme>() ??
      (Theme.of(context).brightness == Brightness.dark ? dark : light);

  static const light = AppButtonTheme(
    primary: AppButtonColors(
      background: AppColors.primary,
      foreground: AppColors.white,
      pressedBackground: AppColors.primary600,
      pressedForeground: AppColors.white,
      disabledBackground: AppColors.grey100,
      disabledForeground: AppColors.grey500,
    ),
    secondary: AppButtonColors(
      background: AppColors.primary50,
      foreground: AppColors.primary,
      pressedBackground: AppColors.primary100,
      pressedForeground: AppColors.primary600,
      disabledBackground: AppColors.grey100,
      disabledForeground: AppColors.grey500,
    ),
    tertiary: AppButtonColors(
      background: AppColors.surface,
      foreground: AppColors.primary,
      border: AppColors.primary,
      pressedBackground: AppColors.primary25,
      pressedForeground: AppColors.primary600,
      pressedBorder: AppColors.primary600,
      disabledBackground: Colors.transparent,
      disabledForeground: AppColors.grey400,
      disabledBorder: AppColors.grey400,
    ),
    destructive: AppButtonColors(
      background: AppColors.surface,
      foreground: AppColors.error,
      border: AppColors.error,
      pressedBackground: AppColors.error50,
      pressedForeground: AppColors.error600,
      pressedBorder: AppColors.error600,
      disabledBackground: Colors.transparent,
      disabledForeground: AppColors.grey400,
      disabledBorder: AppColors.grey400,
    ),
    link: AppButtonColors(
      background: Colors.transparent,
      foreground: AppColors.primary,
      pressedBackground: Colors.transparent,
      pressedForeground: AppColors.primary600,
      disabledBackground: Colors.transparent,
      disabledForeground: AppColors.grey400,
    ),
  );

  static const dark = AppButtonTheme(
    primary: AppButtonColors(
      background: AppDarkColors.primary,
      foreground: AppDarkColors.primary900,
      pressedBackground: AppDarkColors.primary600,
      pressedForeground: AppDarkColors.primary900,
      disabledBackground: AppDarkColors.grey50,
      disabledForeground: AppDarkColors.grey400,
    ),
    secondary: AppButtonColors(
      background: AppDarkColors.primary50,
      foreground: AppDarkColors.primary,
      pressedBackground: AppDarkColors.primary100,
      pressedForeground: AppDarkColors.primary600,
      disabledBackground: AppDarkColors.grey50,
      disabledForeground: AppDarkColors.grey400,
    ),
    tertiary: AppButtonColors(
      background: Colors.transparent,
      foreground: AppDarkColors.primary,
      border: AppDarkColors.primary,
      pressedBackground: AppDarkColors.primary25,
      pressedForeground: AppDarkColors.primary600,
      pressedBorder: AppDarkColors.primary600,
      disabledBackground: Colors.transparent,
      disabledForeground: AppDarkColors.grey400,
      disabledBorder: AppDarkColors.grey200,
    ),
    destructive: AppButtonColors(
      background: Colors.transparent,
      foreground: AppDarkColors.error,
      border: AppDarkColors.error,
      pressedBackground: AppDarkColors.error50,
      pressedForeground: AppDarkColors.error600,
      pressedBorder: AppDarkColors.error600,
      disabledBackground: Colors.transparent,
      disabledForeground: AppDarkColors.grey400,
      disabledBorder: AppDarkColors.grey200,
    ),
    link: AppButtonColors(
      background: Colors.transparent,
      foreground: AppDarkColors.primary,
      pressedBackground: Colors.transparent,
      pressedForeground: AppDarkColors.primary600,
      disabledBackground: Colors.transparent,
      disabledForeground: AppDarkColors.grey400,
    ),
  );

  @override
  AppButtonTheme copyWith({
    AppButtonColors? primary,
    AppButtonColors? secondary,
    AppButtonColors? tertiary,
    AppButtonColors? destructive,
    AppButtonColors? link,
  }) {
    return AppButtonTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      destructive: destructive ?? this.destructive,
      link: link ?? this.link,
    );
  }

  @override
  AppButtonTheme lerp(covariant AppButtonTheme? other, double t) {
    if (other == null) return this;
    return AppButtonTheme(
      primary: AppButtonColors.lerp(primary, other.primary, t),
      secondary: AppButtonColors.lerp(secondary, other.secondary, t),
      tertiary: AppButtonColors.lerp(tertiary, other.tertiary, t),
      destructive: AppButtonColors.lerp(destructive, other.destructive, t),
      link: AppButtonColors.lerp(link, other.link, t),
    );
  }
}
