import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Label + value pill, e.g. "Matures On: 03 Jul 25".
///
/// ```dart
/// const AppInfoTag(label: 'Due on:', value: '03 Jul 25')
/// ```
class AppInfoTag extends StatelessWidget {
  const AppInfoTag({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: dark ? AppDarkColors.yellow100 : AppColors.yellow100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: AppTextStyles.bodyS.semiBold.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            TextSpan(
              text: value,
              style: AppTextStyles.bodyL.semiBold.copyWith(
                color: dark ? AppDarkColors.grey600 : AppColors.grey550,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
