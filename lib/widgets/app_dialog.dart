import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Dialog with a glowing icon, title, message and action buttons.
///
/// ```dart
/// final ok = await AppDialog.show<bool>(
///   icon: Icons.delete_outline,
///   title: 'Delete entry?',
///   message: 'This cannot be undone.',
///   actions: [
///     AppButton(label: 'Cancel', variant: AppButtonVariant.secondary,
///         onPressed: () => Get.back(result: false)),
///     AppButton(label: 'Delete', variant: AppButtonVariant.destructive,
///         onPressed: () => Get.back(result: true)),
///   ],
/// );
/// ```
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.message,
    this.actions = const [],
  });

  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String? message;

  /// Usually two [AppButton]s; they share the row equally.
  final List<Widget> actions;

  static Future<T?> show<T>({
    required String title,
    IconData? icon,
    Color? iconColor,
    String? message,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
  }) {
    return Get.dialog<T>(
      AppDialog(
        title: title,
        icon: icon,
        iconColor: iconColor,
        message: message,
        actions: actions,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = iconColor ?? scheme.primary;
    return Dialog(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.2),
                        blurRadius: 34,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 24, color: accent),
                ),
                const SizedBox(height: 18),
              ],
              Text(
                title,
                style: AppTextStyles.displayS.semiBold.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  style: AppTextStyles.subtitleS.medium.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 28),
                Row(
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(child: actions[i]),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
