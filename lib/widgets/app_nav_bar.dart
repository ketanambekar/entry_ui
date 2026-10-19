import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// One destination of [AppNavBar].
@immutable
class AppNavItem {
  const AppNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.gradient,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;

  /// Paints the icon and label with this gradient (e.g. a premium tab).
  final Gradient? gradient;
}

/// Bottom navigation bar. Use as [Scaffold.bottomNavigationBar].
///
/// ```dart
/// AppNavBar(
///   items: const [
///     AppNavItem(icon: Icons.space_dashboard_outlined, label: 'Dashboard'),
///     AppNavItem(icon: Icons.menu, label: 'More'),
///   ],
///   currentIndex: index,
///   onTap: (i) => setState(() => index = i),
/// )
/// ```
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavSegment(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavSegment extends StatelessWidget {
  const _NavSegment({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    final style = selected
        ? AppTextStyles.bodyS.semiBold
        : AppTextStyles.bodyS.medium;

    Widget icon = Icon(
      selected ? (item.activeIcon ?? item.icon) : item.icon,
      size: 24,
      color: color,
    );
    Widget label = Text(
      item.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: color),
    );
    if (item.gradient != null) {
      icon = _paint(icon, item.gradient!);
      label = _paint(label, item.gradient!);
    }

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                height: 32,
                decoration: BoxDecoration(
                  color: selected && item.gradient == null
                      ? scheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: icon),
              ),
              const SizedBox(height: 4),
              label,
            ],
          ),
        ),
      ),
    );
  }

  Widget _paint(Widget child, Gradient gradient) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: gradient.createShader,
    child: child,
  );
}
