import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

/// Brand-tinted card with an illustration, a question and an action, e.g.
/// "Incorrect details entered?  [Contact us]".
///
/// ```dart
/// AppAlertCard(
///   title: 'Incorrect details entered?',
///   action: AppButton(
///     label: 'Contact us',
///     variant: AppButtonVariant.tertiary,
///     size: AppButtonSize.compact,
///     leading: const Icon(Icons.phone_outlined),
///     onPressed: contact,
///   ),
/// )
/// ```
class AppAlertCard extends StatelessWidget {
  const AppAlertCard({
    super.key,
    required this.title,
    this.action,
    this.illustration,
  });

  final String title;
  final Widget? action;

  /// Defaults to a small "rejected document" illustration.
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final blob = dark ? AppDarkColors.primary100 : AppColors.primary100;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 103),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -40,
            top: -16,
            child: Transform.rotate(
              angle: -0.36,
              child: Container(
                width: 163,
                height: 126,
                decoration: BoxDecoration(
                  color: blob.withValues(alpha: 0.6),
                  borderRadius: const BorderRadius.all(
                    Radius.elliptical(163, 126),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Row(
              children: [
                illustration ?? _DocumentIllustration(accent: blob),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.subtitleXS.bold.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(height: 12),
                        action!,
                      ],
                    ],
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

class _DocumentIllustration extends StatelessWidget {
  const _DocumentIllustration({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final line = scheme.surfaceContainerHigh;

    Widget bar(double w, Color c) => Container(
      width: w,
      height: 5,
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(3),
      ),
    );

    return SizedBox(
      width: 64,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: 0.12,
            child: Container(
              width: 54,
              height: 66,
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: line, width: 0.75),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 1.5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bar(24, accent),
                  bar(36, line),
                  bar(30, line),
                  bar(20, accent),
                  bar(34, line),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: scheme.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: scheme.onError,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
