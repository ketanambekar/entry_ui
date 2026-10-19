import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

enum AppTabsStyle {
  /// Plain labels with an underline under the selected one.
  text,

  /// Outlined rounded boxes; the selected one gets a brand-colour ring.
  boxed,
}

/// One tab of [AppTabs].
@immutable
class AppTab {
  const AppTab(this.label, {this.icon});

  final String label;

  /// Only shown in [AppTabsStyle.boxed].
  final IconData? icon;
}

/// Horizontally scrolling tab strip.
///
/// ```dart
/// AppTabs(
///   tabs: const [AppTab('All'), AppTab('Income'), AppTab('Expense')],
///   selectedIndex: index,
///   onChanged: (i) => setState(() => index = i),
/// )
/// AppTabs(
///   style: AppTabsStyle.boxed,
///   leading: AppFilterButton(onPressed: openFilters),
///   tabs: const [AppTab('Bonds', icon: Icons.bookmark)],
///   ...
/// )
/// ```
class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.style = AppTabsStyle.text,
    this.leading,
    this.padding,
  });

  final List<AppTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppTabsStyle style;

  /// Widget before the first tab, e.g. an [AppFilterButton].
  final Widget? leading;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final idle = dark ? AppDarkColors.grey600 : AppColors.grey600;
    final isText = style == AppTabsStyle.text;

    final children = <Widget>[
      ?leading,
      for (var i = 0; i < tabs.length; i++)
        isText
            ? _textTab(tabs[i], i == selectedIndex, scheme, idle, i)
            : _boxedTab(tabs[i], i == selectedIndex, scheme, idle, i),
    ];

    final strip = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding:
          padding ??
          (isText ? const EdgeInsets.symmetric(horizontal: 16) : null),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: isText ? 20 : 8),
            children[i],
          ],
        ],
      ),
    );

    if (!isText) return strip;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: strip,
    );
  }

  Widget _textTab(
    AppTab tab,
    bool selected,
    ColorScheme scheme,
    Color idle,
    int index,
  ) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: () => onChanged(index),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                tab.label,
                style: AppTextStyles.bodyL.semiBold.copyWith(
                  color: selected ? scheme.primary : idle,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 2,
                color: selected ? scheme.primary : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boxedTab(
    AppTab tab,
    bool selected,
    ColorScheme scheme,
    Color idle,
    int index,
  ) {
    final color = selected ? scheme.primary : idle;
    return Semantics(
      selected: selected,
      button: true,
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: InkWell(
          onTap: () => onChanged(index),
          borderRadius: BorderRadius.circular(8),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.25),
                    spreadRadius: 1.5,
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tab.icon != null) ...[
                  Icon(tab.icon, size: 16, color: color),
                  const SizedBox(width: 4),
                ],
                Text(
                  tab.label,
                  style: AppTextStyles.bodyL.semiBold.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
