import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/widgets/app_button.dart';

/// Dashed upload area.
///
/// * no [preview]: empty state with an upload icon and [uploadLabel] button
/// * with [preview]: "Preview:" + the preview widget + [replaceLabel] button
/// * [errorText]: shown under the preview (e.g. file too large)
///
/// ```dart
/// AppUploadCard(onUpload: pickFile)
/// AppUploadCard(
///   preview: Image.file(file, fit: BoxFit.cover),
///   errorText: tooBig ? 'Please upload a file smaller than 10 MB.' : null,
///   onUpload: pickFile,
/// )
/// ```
class AppUploadCard extends StatelessWidget {
  const AppUploadCard({
    super.key,
    required this.onUpload,
    this.preview,
    this.errorText,
    this.uploadLabel = 'Upload file',
    this.replaceLabel = 'Re-upload',
    this.icon = Icons.cloud_upload_outlined,
  });

  final VoidCallback? onUpload;
  final Widget? preview;
  final String? errorText;
  final String uploadLabel;
  final String replaceLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Widget content;
    if (preview == null) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.2),
                    blurRadius: 34,
                  ),
                ],
              ),
              child: Icon(icon, size: 24, color: scheme.primary),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: uploadLabel,
              variant: AppButtonVariant.secondary,
              onPressed: onUpload,
            ),
          ],
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Preview:',
              style: AppTextStyles.bodyL.medium.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: preview,
              ),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.error_rounded, size: 16, color: scheme.error),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      errorText!,
                      style: AppTextStyles.bodyS.semiBold.copyWith(
                        color: scheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            Center(
              child: AppButton(
                label: replaceLabel,
                variant: AppButtonVariant.secondary,
                leading: const Icon(Icons.upload_rounded),
                onPressed: onUpload,
              ),
            ),
          ],
        ),
      );
    }

    return CustomPaint(
      foregroundPainter: _DashedRRectPainter(
        color: errorText != null ? scheme.error : scheme.outlineVariant,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.5),
          const Radius.circular(8),
        ),
      );
    for (final PathMetric m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 9) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) => old.color != color;
}
