import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Full-width consent / disclaimer block, usually pinned above a bottom CTA.
///
/// ```dart
/// const AppDisclaimer('By continuing, you agree to our terms…')
/// ```
class AppDisclaimer extends StatelessWidget {
  const AppDisclaimer(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyM.semiBold.copyWith(color: scheme.onSurface),
      ),
    );
  }
}
