import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/widgets/app_radio.dart';

/// Selectable option card with a radio indicator. Pass [icon] for the tall
/// variant (icon, title, description), omit it for the compact one.
///
/// ```dart
/// AppSelectionCard<String>(
///   value: 'camera',
///   groupValue: source,
///   onChanged: (v) => setState(() => source = v),
///   icon: Icons.photo_camera_outlined,
///   title: 'Camera',
///   description: 'Take a new photo',
/// )
/// ```
class AppSelectionCard<T> extends StatelessWidget {
  const AppSelectionCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.description,
    this.icon,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String title;
  final String? description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = value == groupValue;
    final enabled = onChanged != null;
    final radius = BorderRadius.circular(8);

    final radio = IgnorePointer(
      child: AppRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: enabled ? (_) {} : null,
      ),
    );

    final titleText = Text(
      title,
      style: AppTextStyles.bodyL.bold.copyWith(
        color: enabled
            ? scheme.onSurface
            : scheme.onSurface.withValues(alpha: 0.38),
      ),
    );

    final Widget body;
    if (icon != null) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          children: [
            Align(alignment: Alignment.topRight, child: radio),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.2),
                    blurRadius: 34,
                  ),
                ],
              ),
              child: Icon(icon, size: 44, color: scheme.primary),
            ),
            const SizedBox(height: 12),
            titleText,
            if (description != null) ...[
              const SizedBox(height: 2),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyS.semiBold.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      body = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          children: [
            Expanded(child: titleText),
            const SizedBox(width: 12),
            radio,
          ],
        ),
      );
    }

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? () => onChanged!(value) : null,
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: selected ? scheme.primaryContainer : scheme.surface,
                borderRadius: radius,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant,
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.25),
                      spreadRadius: 1.5,
                    ),
                ],
              ),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
