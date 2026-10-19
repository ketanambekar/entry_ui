import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

enum AppTagTone { neutral, brand, success, warning, caution, error, purple }

enum AppTagStyle {
  /// Tinted fill + tinted border (status / rating tags).
  soft,

  /// Strong fill with white text (e.g. "SELL INSTANTLY").
  solid,

  /// Surface fill, neutral border, coloured text.
  outlined,
}

/// Small status tag.
///
/// ```dart
/// const AppTag('AAA+', tone: AppTagTone.success)
/// const AppTag('SELL INSTANTLY', tone: AppTagTone.warning, style: AppTagStyle.solid)
/// const AppTag('BONDS', style: AppTagStyle.outlined, count: 3)
/// ```
class AppTag extends StatelessWidget {
  const AppTag(
    this.label, {
    super.key,
    this.tone = AppTagTone.neutral,
    this.style = AppTagStyle.soft,
    this.count,
    this.icon,
  });

  final String label;
  final AppTagTone tone;
  final AppTagStyle style;

  /// Number shown in a small box before the label.
  final int? count;
  final IconData? icon;

  static TagColors colorsOf(BuildContext context, AppTagTone tone) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return switch (tone) {
      AppTagTone.neutral => dark ? AppDarkColors.tagGrey : AppColors.tagGrey,
      AppTagTone.brand => dark ? AppDarkColors.tagBlue : AppColors.tagBlue,
      AppTagTone.success => dark ? AppDarkColors.tagGreen : AppColors.tagGreen,
      AppTagTone.warning => dark ? AppDarkColors.tagAmber : AppColors.tagAmber,
      AppTagTone.caution =>
        dark ? AppDarkColors.tagOrange : AppColors.tagOrange,
      AppTagTone.error => dark ? AppDarkColors.tagRed : AppColors.tagRed,
      AppTagTone.purple => dark ? AppDarkColors.tagPurple : AppColors.tagPurple,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tag = colorsOf(context, tone);
    final solid = tone == AppTagTone.warning
        ? (dark ? AppDarkColors.yellow800 : AppColors.yellow800)
        : tag.text;
    final (fill, border, text) = switch (style) {
      AppTagStyle.soft => (tag.fill, tag.stroke, tag.text),
      AppTagStyle.solid => (solid, solid, scheme.surface),
      AppTagStyle.outlined => (scheme.surface, scheme.outlineVariant, tag.text),
    };

    return Container(
      padding: EdgeInsets.fromLTRB(count != null ? 4 : 8, 4, 8, 4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count != null) ...[
            Container(
              constraints: const BoxConstraints(minWidth: 14),
              height: 14,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.capsT.bold.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyT.bold.copyWith(color: text),
            ),
          ),
        ],
      ),
    );
  }
}
