import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Toggleable filter chip; selected chips get a brand ring and a clear (×)
/// button.
///
/// ```dart
/// AppFilterChip(
///   label: 'Highest rated',
///   selected: on,
///   onSelected: (v) => setState(() => on = v),
/// )
/// ```
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final enabled = onSelected != null;

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: InkWell(
          onTap: enabled ? () => onSelected!(!selected) : null,
          borderRadius: BorderRadius.circular(8),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 32,
            padding: EdgeInsets.only(left: 16, right: selected ? 4 : 16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.25),
                    spreadRadius: 1.5,
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyM.semiBold.copyWith(
                    color: enabled
                        ? (dark ? AppDarkColors.grey600 : AppColors.grey600)
                        : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 3),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
