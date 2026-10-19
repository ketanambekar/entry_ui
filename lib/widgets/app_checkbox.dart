import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Design-system checkbox with an optional label (one line or a paragraph).
///
/// [value] `null` shows the indeterminate (−) state, e.g. for "select all".
/// Tapping an unchecked or indeterminate box checks it; tapping a checked box
/// clears it. Pass `onChanged: null` to disable.
///
/// ```dart
/// AppCheckbox(
///   value: agreed,
///   label: 'I agree to the terms',
///   onChanged: (v) => setState(() => agreed = v),
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.maxLines,
  });

  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final enabled = onChanged != null;
    final checked = value != false;
    final disabledFill = dark ? AppDarkColors.grey200 : AppColors.grey200;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked
            ? (enabled ? scheme.primary : disabledFill)
            : (enabled ? scheme.surface : Colors.transparent),
        borderRadius: BorderRadius.circular(4),
        border: checked
            ? null
            : Border.all(
                color: enabled ? scheme.outline : scheme.outlineVariant,
              ),
      ),
      child: value == null
          ? Icon(Icons.remove_rounded, size: 16, color: scheme.onPrimary)
          : value!
          ? Icon(Icons.check_rounded, size: 14, color: scheme.onPrimary)
          : null,
    );

    return MergeSemantics(
      child: Semantics(
        checked: value ?? false,
        mixed: value == null,
        enabled: enabled,
        child: InkWell(
          onTap: enabled ? () => onChanged!(value != true) : null,
          borderRadius: BorderRadius.circular(4),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: label == null
              ? box
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    box,
                    const SizedBox(width: 12),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          label!,
                          maxLines: maxLines,
                          overflow: maxLines == null
                              ? null
                              : TextOverflow.ellipsis,
                          style: AppTextStyles.bodyM.semiBold.copyWith(
                            color: enabled
                                ? scheme.onSurface
                                : scheme.onSurface.withValues(alpha: 0.38),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
