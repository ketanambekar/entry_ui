import 'package:flutter/material.dart';

/// Design-system colour palette. Numbers follow a 25–900 scale
/// (lower = lighter).
abstract final class AppColors {
  // Brand (navy blue) — all clickable/interactive elements.
  static const primary25 = Color(0xFFF5F8FD);
  static const primary50 = Color(0xFFEAF0FA); // Tertiary button / section BG
  static const primary100 = Color(0xFFC8D6F0); // Strokes, secondary BG
  static const primary300 = Color(0xFF6F8FD0);
  static const primary = Color(0xFF1F3F8F); // CTAs
  static const primary600 = Color(0xFF183376); // Text buttons, clickable tags
  static const primary800 = Color(0xFF0F1F4A);
  static const primary900 = Color(0xFF0A1430); // Deep secondary BGs

  // Accent (light / sky blue) — highlights and special icons.
  static const accent50 = Color(0xFFEAF5FF);
  static const accent100 = Color(0xFFCFE7FD);
  static const accent = Color(0xFF3B9BEF);
  static const accent600 = Color(0xFF1D6CB8);

  // Neutrals (cool, blue-tinted) — text, form fields, backgrounds, dividers.
  static const white = Color(0xFFFFFFFF);
  static const surface = white; // Cards, sheets, app bars
  static const grey25 = Color(0xFFF7F8FB); // Page / card BG
  static const grey50 = Color(0xFFEFF1F5); // Dividers
  static const grey100 = Color(0xFFE4E8EE); // Card strokes
  static const grey200 = Color(0xFFB9C0CB);
  static const grey400 = Color(0xFF939BA8); // Subtext, tags
  static const grey500 = Color(0xFF6B7380); // Labels
  static const grey550 = Color(0xFF515866);
  static const grey600 = Color(0xFF303642); // Subtext on coloured BGs
  static const grey800 = Color(0xFF111723); // Headings

  // Yellow — notes/alerts and gamification.
  static const yellow100 = Color(0xFFFFF8E0); // Note / alert BG
  static const yellow500 = Color(0xFFFCD63C); // Note / alert stroke
  static const yellow800 = Color(0xFFFFB038);

  // Success — non-clickable positive info.
  static const success25 = Color(0xFFF5FBF7);
  static const success50 = Color(0xFFE6F5EC);
  static const success100 = Color(0xFFCDEED8);
  static const success = Color(0xFF17A84A);
  static const success600 = Color(0xFF13793A);

  // Error — negative actions and info.
  static const error50 = Color(0xFFFDECED);
  static const error = Color(0xFFD63336);
  static const error600 = Color(0xFFB92A2D);

  // Charts / graphs — distinct from the brand blue.
  static const chartSky = Color(0xFF3B9BEF);
  static const chartViolet = Color(0xFF8A70F8);
  static const chartPink = Color(0xFFF7718A);
  static const chartTeal = Color(0xFF0FA38A);
  static const chartOrange = Color(0xFFF58A3D);
  static const chartAmber = Color(0xFFF5BE3F);

  // Status tags / cards (fill, stroke, text).
  static const tagBlue = TagColors(
    fill: primary50,
    stroke: primary100,
    text: primary600,
  );
  static const tagAmber = TagColors(
    fill: Color(0xFFFFF7EA),
    stroke: Color(0xFFFDE8C4),
    text: Color(0xFF9A5E05),
  );
  static const tagOrange = TagColors(
    fill: Color(0xFFFEF4EE),
    stroke: Color(0xFFF8DDCB),
    text: Color(0xFFB34B10),
  );
  static const tagRed = TagColors(
    fill: Color(0xFFFEF4F4),
    stroke: Color(0xFFF8E0E1),
    text: Color(0xFFA2261F),
  );
  static const tagPurple = TagColors(
    fill: Color(0xFFF5F3FE),
    stroke: Color(0xFFE4DFF7),
    text: Color(0xFF5B2BB5),
  );
  static const tagGreen = TagColors(
    fill: success50,
    stroke: success100,
    text: success600,
  );
  static const tagGrey = TagColors(
    fill: grey25,
    stroke: grey100,
    text: grey500,
  );
}

/// Dark-mode palette. Same names and roles as [AppColors], so swapping
/// palettes is a drop-in change: dark surfaces are navy-tinted, brand and
/// status colours are lightened for contrast on dark backgrounds.
abstract final class AppDarkColors {
  // Brand (navy blue).
  static const primary25 = Color(0xFF0F1830);
  static const primary50 = Color(0xFF15234A); // Tertiary button / section BG
  static const primary100 = Color(0xFF22366E); // Strokes, secondary BG
  static const primary300 = Color(0xFF4D6BC0);
  static const primary = Color(0xFF7F9DF0); // CTAs
  static const primary600 = Color(0xFFA6BBF6); // Text buttons, clickable tags
  static const primary800 = Color(0xFFC8D5FA);
  static const primary900 = Color(0xFF060B1A); // Deep BGs, text on CTAs

  // Accent (light / sky blue).
  static const accent50 = Color(0xFF0E2A44);
  static const accent100 = Color(0xFF164168);
  static const accent = Color(0xFF5AB0F5);
  static const accent600 = Color(0xFF8CC8F8);

  // Neutrals — scale is inverted: 25 is the darkest BG, 800 the lightest text.
  static const white = Color(0xFFFFFFFF);
  static const surface = Color(0xFF131B2E); // Cards, sheets, app bars
  static const grey25 = Color(0xFF0B1120); // Page BG
  static const grey50 = Color(0xFF1B2436); // Dividers
  static const grey100 = Color(0xFF263046); // Card strokes
  static const grey200 = Color(0xFF3B4660);
  static const grey400 = Color(0xFF8A93A6); // Subtext, tags
  static const grey500 = Color(0xFFA3ABBC); // Labels
  static const grey550 = Color(0xFFBDC4D1);
  static const grey600 = Color(0xFFD3D8E2); // Subtext on coloured BGs
  static const grey800 = Color(0xFFEEF1F7); // Headings

  // Yellow — notes/alerts and gamification.
  static const yellow100 = Color(0xFF2E2610); // Note / alert BG
  static const yellow500 = Color(0xFFC9A72A); // Note / alert stroke
  static const yellow800 = Color(0xFFFFC25A);

  // Success.
  static const success25 = Color(0xFF0E1F16);
  static const success50 = Color(0xFF12291C);
  static const success100 = Color(0xFF1B4A2E);
  static const success = Color(0xFF3CCB6C);
  static const success600 = Color(0xFF6EDC93);

  // Error.
  static const error50 = Color(0xFF2E1416);
  static const error = Color(0xFFF2686A);
  static const error600 = Color(0xFFF7979A);

  // Charts / graphs.
  static const chartSky = Color(0xFF5AB0F5);
  static const chartViolet = Color(0xFFA08CFA);
  static const chartPink = Color(0xFFF98AA0);
  static const chartTeal = Color(0xFF2DC2A6);
  static const chartOrange = Color(0xFFF89E5C);
  static const chartAmber = Color(0xFFF7CB5E);

  // Status tags / cards (fill, stroke, text).
  static const tagBlue = TagColors(
    fill: primary50,
    stroke: primary100,
    text: primary600,
  );
  static const tagAmber = TagColors(
    fill: Color(0xFF2B2110),
    stroke: Color(0xFF4A3714),
    text: Color(0xFFF2BE5E),
  );
  static const tagOrange = TagColors(
    fill: Color(0xFF2C1A10),
    stroke: Color(0xFF4D2C17),
    text: Color(0xFFF59E66),
  );
  static const tagRed = TagColors(
    fill: Color(0xFF2D1414),
    stroke: Color(0xFF4E2222),
    text: Color(0xFFF28B85),
  );
  static const tagPurple = TagColors(
    fill: Color(0xFF1F1838),
    stroke: Color(0xFF352A5E),
    text: Color(0xFFB9A3F7),
  );
  static const tagGreen = TagColors(
    fill: success50,
    stroke: success100,
    text: success600,
  );
  static const tagGrey = TagColors(
    fill: grey50,
    stroke: grey100,
    text: grey500,
  );
}

/// Fill, stroke and text colours for a status tag or card.
class TagColors {
  const TagColors({
    required this.fill,
    required this.stroke,
    required this.text,
  });

  final Color fill;
  final Color stroke;
  final Color text;
}
