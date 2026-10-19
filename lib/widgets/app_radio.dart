import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Design-system radio button with an optional label.
/// Pass `onChanged: null` to disable.
///
/// ```dart
/// AppRadio<String>(
///   value: 'upi',
///   groupValue: method,
///   label: 'UPI',
///   onChanged: (v) => setState(() => method = v),
/// )
/// ```
class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onChanged != null;
    final selected = value == groupValue;
    final accent = enabled ? scheme.primary : scheme.outlineVariant;

    final circle = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? scheme.surface : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.25,
          color: selected
              ? accent
              : (enabled ? scheme.outline : scheme.outlineVariant),
        ),
      ),
      child: AnimatedScale(
        scale: selected ? 1 : 0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
        ),
      ),
    );

    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        enabled: enabled,
        child: InkWell(
          onTap: enabled && !selected ? () => onChanged!(value) : null,
          borderRadius: BorderRadius.circular(10),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: label == null
              ? circle
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    circle,
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label!,
                        style: AppTextStyles.bodyM.semiBold.copyWith(
                          color: enabled
                              ? scheme.onSurface
                              : scheme.onSurface.withValues(alpha: 0.38),
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
