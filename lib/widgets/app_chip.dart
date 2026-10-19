import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Rounded pill chip, e.g. for nominees or recipients.
///
/// * default: neutral outline
/// * [selected]: brand outline + text
/// * [onRemove]: shows a close icon
/// * [AppChip.add]: dashed "add" chip
///
/// ```dart
/// AppChip(label: 'Nominee 1 (50%)', onTap: edit)
/// AppChip(label: 'Nominee 2 (50%)', selected: true, onRemove: remove)
/// AppChip.add(label: 'Add nominee', onTap: add)
/// ```
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onRemove,
  }) : _isAdd = false;

  const AppChip.add({super.key, required this.label, this.onTap})
    : selected = false,
      onRemove = null,
      _isAdd = true;

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool _isAdd;

  static const _radius = BorderRadius.all(Radius.circular(28));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = selected || _isAdd;
    final color = accent
        ? scheme.primary
        : (dark ? AppDarkColors.grey600 : AppColors.grey600);

    Widget chip = Container(
      height: 40,
      padding: EdgeInsets.only(
        left: 16,
        right: onRemove != null || _isAdd ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: _isAdd ? scheme.primaryContainer : scheme.surface,
        borderRadius: _radius,
        border: _isAdd
            ? null
            : Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyM.semiBold.copyWith(color: color),
            ),
          ),
          if (_isAdd) ...[
            const SizedBox(width: 6),
            Icon(Icons.add_rounded, size: 20, color: color),
          ],
          if (onRemove != null) ...[
            const SizedBox(width: 6),
            Semantics(
              button: true,
              label: 'Remove $label',
              child: InkResponse(
                onTap: onRemove,
                radius: 16,
                child: Icon(Icons.close_rounded, size: 20, color: color),
              ),
            ),
          ],
        ],
      ),
    );

    if (_isAdd) {
      chip = CustomPaint(
        foregroundPainter: _DashedBorderPainter(
          color: dark ? AppDarkColors.primary100 : AppColors.primary100,
          radius: 28,
        ),
        child: chip,
      );
    }

    return Semantics(
      button: onTap != null,
      selected: selected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: _radius,
          splashFactory: NoSplash.splashFactory,
          child: chip,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.5),
          Radius.circular(radius),
        ),
      );
    for (final PathMetric metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 7) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
