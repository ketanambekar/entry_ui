import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Shows how much of something is sold out / used up.
/// At 100% it becomes a solid badge; below that it shows the percentage
/// above a soft tag.
///
/// ```dart
/// const AppSoldOutBadge(percent: 50)
/// const AppSoldOutBadge(percent: 100)
/// ```
class AppSoldOutBadge extends StatelessWidget {
  const AppSoldOutBadge({
    super.key,
    required this.percent,
    this.label = 'SOLD OUT',
  });

  final double percent;
  final String label;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tag = dark ? AppDarkColors.tagRed : AppColors.tagRed;
    final solid = dark ? AppDarkColors.error : AppColors.error;
    final full = percent >= 100;
    final style = AppTextStyles.bodyT.bold;

    final amount = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: solid.withValues(alpha: 0.24),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.priority_high_rounded, size: 9, color: tag.text),
        ),
        const SizedBox(width: 2),
        Text(
          '${percent.clamp(0, 100).round()}%',
          style: style.copyWith(color: tag.text),
        ),
      ],
    );

    if (!full) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          amount,
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tag.fill,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: tag.stroke),
            ),
            child: Text(label, style: style.copyWith(color: tag.text)),
          ),
        ],
      );
    }

    return Container(
      width: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: tag.stroke),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 25,
            color: solid,
            alignment: Alignment.center,
            child: Text(label, style: style.copyWith(color: Colors.white)),
          ),
          SizedBox(height: 24, child: Center(child: amount)),
        ],
      ),
    );
  }
}
