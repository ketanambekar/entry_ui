import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Sort selector: equal-width segments, the active one shows a sort arrow.
/// Tapping a new segment selects it (descending); tapping the active one
/// flips the direction.
///
/// ```dart
/// AppSortBar(
///   labels: const ['Amount', 'Date', 'Name'],
///   selectedIndex: sortIndex,
///   ascending: ascending,
///   onChanged: (i, asc) => setState(() {
///     sortIndex = i;
///     ascending = asc;
///   }),
/// )
/// ```
class AppSortBar extends StatelessWidget {
  const AppSortBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.ascending,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final bool ascending;
  final void Function(int index, bool ascending) onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = BorderSide(color: scheme.outlineVariant);
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color(0x1207213B), blurRadius: 15, spreadRadius: 4),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selectedIndex,
                child: InkWell(
                  onTap: () =>
                      onChanged(i, i == selectedIndex ? !ascending : false),
                  splashFactory: NoSplash.splashFactory,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      border: Border(
                        top: border,
                        right: border,
                        left: i == 0 ? border : BorderSide.none,
                      ),
                    ),
                    child: _segment(labels[i], i == selectedIndex, scheme),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _segment(String label, bool selected, ColorScheme scheme) {
    final color = selected ? scheme.primary : scheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (selected) ...[
          Icon(Icons.sort_rounded, size: 14, color: color),
          AnimatedRotation(
            turns: ascending ? 0.5 : 0,
            duration: const Duration(milliseconds: 150),
            child: Icon(Icons.arrow_downward_rounded, size: 14, color: color),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyS.semiBold.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
