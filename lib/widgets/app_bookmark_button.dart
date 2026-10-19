import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';

/// Bookmark / save toggle.
/// Set [onDarkBackground] when it sits on a dark image or card.
///
/// ```dart
/// AppBookmarkButton(
///   isSaved: saved,
///   onChanged: (v) => setState(() => saved = v),
/// )
/// ```
class AppBookmarkButton extends StatelessWidget {
  const AppBookmarkButton({
    super.key,
    required this.isSaved,
    required this.onChanged,
    this.onDarkBackground = false,
    this.size = 24,
  });

  final bool isSaved;
  final ValueChanged<bool>? onChanged;
  final bool onDarkBackground;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final idle = onDarkBackground
        ? AppColors.grey600
        : (dark ? AppDarkColors.grey200 : AppColors.grey200);

    return IconButton(
      onPressed: onChanged == null ? null : () => onChanged!(!isSaved),
      tooltip: isSaved ? 'Remove bookmark' : 'Bookmark',
      isSelected: isSaved,
      iconSize: size,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size.square(size + 8)),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: Colors.transparent,
      ),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (child, a) =>
            ScaleTransition(scale: a, child: child),
        child: Icon(
          Icons.bookmark,
          key: ValueKey(isSaved),
          color: isSaved ? scheme.primary : idle,
        ),
      ),
    );
  }
}
