import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Highlighted note with an info badge and a heading.
///
/// ```dart
/// const AppNoteCard(message: 'Your data is encrypted and never shared.')
/// const AppNoteCard(title: 'TIP', message: 'Swipe left to delete.')
/// ```
class AppNoteCard extends StatelessWidget {
  const AppNoteCard({
    super.key,
    required this.message,
    this.title = 'NOTE',
    this.icon = Icons.priority_high_rounded,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 10, color: scheme.onPrimary),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.bodyS.bold.copyWith(color: scheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyM.medium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
