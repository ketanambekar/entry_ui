import 'package:flutter/material.dart';

/// Square outlined filter button; [isActive] adds a dot when filters apply.
///
/// ```dart
/// AppFilterButton(isActive: hasFilters, onPressed: openFilterSheet)
/// ```
class AppFilterButton extends StatelessWidget {
  const AppFilterButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
    this.icon = Icons.filter_alt_outlined,
    this.tooltip = 'Filter',
  });

  final VoidCallback? onPressed;
  final bool isActive;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: isActive ? '$tooltip, active' : tooltip,
        excludeSemantics: true,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          splashFactory: NoSplash.splashFactory,
          child: Ink(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: onPressed == null ? scheme.outline : scheme.primary,
                ),
                if (isActive)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(1.5),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.25),
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
