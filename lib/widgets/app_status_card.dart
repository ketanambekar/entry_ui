import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/widgets/app_tag.dart';

/// Label / value pair shown in an [AppStatusCard] stats row.
class AppStat {
  const AppStat(this.label, this.value, {this.color, this.emphasize = true});

  final String label;
  final String value;
  final Color? color;

  /// Bold value when true, medium otherwise.
  final bool emphasize;
}

/// Card wrapped in a coloured status frame, e.g. order / transaction status.
///
/// ```dart
/// AppStatusCard(
///   status: 'PAYMENT DONE',
///   tone: AppTagTone.success,
///   title: 'Monthly rent',
///   subtitle: 'TXN-000123',
///   tags: const [AppTag('PAID', tone: AppTagTone.success)],
///   trailing: '3 Qty',
///   stats: const [
///     [AppStat('Amount', '₹20,000'), AppStat('Due', '05 Jul')],
///   ],
///   actions: [AppButton(label: 'Receipt', onPressed: open)],
/// )
/// ```
class AppStatusCard extends StatelessWidget {
  const AppStatusCard({
    super.key,
    required this.status,
    required this.title,
    this.tone = AppTagTone.success,
    this.statusIcon,
    this.subtitle,
    this.leading,
    this.tags = const [],
    this.trailing,
    this.stats = const [],
    this.note,
    this.actions = const [],
    this.onTap,
  });

  final String status;
  final AppTagTone tone;

  /// Icon inside the status dot; defaults per tone.
  final IconData? statusIcon;
  final String title;
  final String? subtitle;

  /// Usually a 40×40 logo / avatar.
  final Widget? leading;
  final List<Widget> tags;

  /// Small pill on the right of the tags row (e.g. "3 Qty").
  final String? trailing;

  /// Each inner list renders as one row of stats separated by dividers.
  final List<List<AppStat>> stats;

  /// Highlighted message (e.g. a cancellation reason).
  final String? note;
  final List<Widget> actions;
  final VoidCallback? onTap;

  IconData get _icon =>
      statusIcon ??
      switch (tone) {
        AppTagTone.success => Icons.check_rounded,
        AppTagTone.error => Icons.close_rounded,
        AppTagTone.warning || AppTagTone.caution => Icons.schedule_rounded,
        _ => Icons.circle,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final c = AppTag.colorsOf(context, tone);
    final grey550 = dark ? AppDarkColors.grey550 : AppColors.grey550;
    final statBg = dark ? AppDarkColors.grey25 : AppColors.grey25;

    Widget statsRow(List<AppStat> row) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [statBg, statBg.withValues(alpha: 0)]),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var i = 0; i < row.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 24,
                  thickness: 1,
                  color: scheme.outlineVariant,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row[i].label,
                      style: AppTextStyles.bodyT.semiBold.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      row[i].value,
                      style:
                          (row[i].emphasize
                                  ? AppTextStyles.bodyM.bold
                                  : AppTextStyles.bodyM.medium)
                              .copyWith(
                                color:
                                    row[i].color ??
                                    (row[i].emphasize
                                        ? scheme.onSurface
                                        : grey550),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );

    final inner = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: leading,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subtitleS.semiBold.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.caps.medium.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty || trailing != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Wrap(spacing: 6, runSpacing: 6, children: tags),
                ),
                if (trailing != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trailing!,
                      style: AppTextStyles.caps.semiBold.copyWith(
                        color: grey550,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          for (final row in stats) ...[
            const SizedBox(height: 12),
            statsRow(row),
          ],
          if (note != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.stroke),
              ),
              child: Text(
                note!,
                style: AppTextStyles.bodyS.bold.copyWith(color: c.text),
              ),
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(height: 1, color: scheme.outlineVariant),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  actions[i],
                ],
              ],
            ),
          ],
        ],
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: c.fill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: c.text,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_icon, size: 10, color: scheme.surface),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        status,
                        style: AppTextStyles.capsT.bold.copyWith(color: c.text),
                      ),
                    ),
                  ],
                ),
              ),
              inner,
            ],
          ),
        ),
      ),
    );
  }
}
