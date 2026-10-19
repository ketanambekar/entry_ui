import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:entry_ui/playground/playground_kit.dart';
import 'package:entry_ui/theme/app_icons.dart';
import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/widgets/app_toast.dart';

class PlaygroundIconsTab extends StatefulWidget {
  const PlaygroundIconsTab({super.key});

  @override
  State<PlaygroundIconsTab> createState() => _PlaygroundIconsTabState();
}

class _PlaygroundIconsTabState extends State<PlaygroundIconsTab> {
  double _size = AppIcons.md;

  Future<void> _copy(String name) async {
    final size = switch (_size) {
      AppIcons.sm => 'AppIcons.sm',
      AppIcons.lg => 'AppIcons.lg',
      _ => 'AppIcons.md',
    };
    await Clipboard.setData(
      ClipboardData(text: 'Icon(AppIcons.$name, size: $size)'),
    );
    AppToast.show('Copied AppIcons.$name');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'Size',
          children: [
            SegmentedButton<double>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: AppIcons.sm, label: Text('sm · 16')),
                ButtonSegment(value: AppIcons.md, label: Text('md · 24')),
                ButtonSegment(value: AppIcons.lg, label: Text('lg · 36')),
              ],
              selected: {_size},
              onSelectionChanged: (s) => setState(() => _size = s.first),
            ),
          ],
        ),
        PlaygroundSection(
          'AppIcons — tap to copy',
          children: [
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
              children: [
                for (final MapEntry(key: name, value: icon)
                    in AppIcons.all.entries)
                  Material(
                    color: scheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: scheme.outlineVariant),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _copy(name),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: _size, color: scheme.onSurface),
                            const SizedBox(height: 8),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyT.medium.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
