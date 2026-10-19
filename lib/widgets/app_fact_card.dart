import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Dark gradient card for tips / trivia ("Did you know?").
///
/// ```dart
/// const AppFactCard(
///   title: 'Did you know?',
///   message: 'Tracking daily expenses can cut spending by 15%.',
/// )
/// ```
class AppFactCard extends StatelessWidget {
  const AppFactCard({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.bolt_rounded,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [AppColors.primary900, Color(0xFF16181D)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -120,
            top: -180,
            child: Container(
              width: 308,
              height: 308,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 0.12, 0.22],
                  colors: [
                    Colors.white.withValues(alpha: 0.18),
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 20, color: AppDarkColors.accent),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyles.subtitleM.bold.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: AppTextStyles.subtitleXS.medium.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
