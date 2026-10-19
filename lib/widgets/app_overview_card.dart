import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Label / value pair used by [AppOverviewCard].
class AppOverviewItem {
  const AppOverviewItem(this.label, this.value);

  final String label;
  final String value;
}

/// Titled card listing label/value pairs in columns.
///
/// ```dart
/// AppOverviewCard(
///   title: 'Overview',
///   items: const [
///     AppOverviewItem('Category', 'Groceries'),
///     AppOverviewItem('Amount', '₹1,250'),
///   ],
/// )
/// ```
class AppOverviewCard extends StatelessWidget {
  const AppOverviewCard({
    super.key,
    required this.title,
    required this.items,
    this.columns = 2,
    this.trailing,
  }) : assert(columns > 0);

  final String title;
  final List<AppOverviewItem> items;
  final int columns;

  /// Optional widget next to the title (e.g. an edit link).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final perColumn = (items.length / columns).ceil();

    Widget item(AppOverviewItem i) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i.label,
          style: AppTextStyles.bodyM.regular.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          i.value,
          style: AppTextStyles.bodyL.semiBold.copyWith(
            color: dark ? AppDarkColors.grey600 : AppColors.grey600,
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? AppDarkColors.grey25 : AppColors.grey25,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subtitleM.semiBold.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, thickness: 1, color: scheme.outlineVariant),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var c = 0; c < columns; c++) ...[
                if (c > 0) const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (
                        var r = c * perColumn;
                        r < (c + 1) * perColumn && r < items.length;
                        r++
                      ) ...[
                        if (r > c * perColumn) const SizedBox(height: 16),
                        item(items[r]),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
