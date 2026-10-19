import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// One tab of [AppIconTabs].
@immutable
class AppIconTab {
  const AppIconTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Compact category tabs: unselected tabs show only their icon, the selected
/// one expands to icon + label with an underline.
///
/// ```dart
/// AppIconTabs(
///   tabs: const [
///     AppIconTab(icon: Icons.apartment, label: 'Corporate'),
///     AppIconTab(icon: Icons.account_balance, label: 'Govt'),
///   ],
///   selectedIndex: index,
///   onChanged: (i) => setState(() => index = i),
/// )
/// ```
class AppIconTabs extends StatelessWidget {
  const AppIconTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<AppIconTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              _tab(tabs[i], i == selectedIndex, scheme, i),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tab(AppIconTab tab, bool selected, ColorScheme scheme, int index) {
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Tooltip(
      message: selected ? '' : tab.label,
      child: Semantics(
        selected: selected,
        button: true,
        label: tab.label,
        excludeSemantics: true,
        child: InkWell(
          onTap: () => onChanged(index),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          child: Icon(tab.icon, size: 24, color: color),
                        ),
                        if (selected)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              tab.label,
                              style: AppTextStyles.subtitleXS.semiBold.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    color: selected ? scheme.primary : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
