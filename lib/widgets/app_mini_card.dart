import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Small non-clickable info card.
///
/// ```dart
/// const AppMiniCard(label: '100%')
/// const AppMiniCard.icon(icon: Icons.badge_outlined, label: 'ID card')
/// ```
class AppMiniCard extends StatelessWidget {
  const AppMiniCard({super.key, required this.label}) : icon = null;

  const AppMiniCard.icon({
    super.key,
    required IconData this.icon,
    required this.label,
  });

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    if (icon == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyS.semiBold.copyWith(color: scheme.onSurface),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: scheme.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.medium.copyWith(
              color: dark ? AppDarkColors.grey600 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
