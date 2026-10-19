import 'package:flutter/material.dart';

import 'package:entry_ui/playground/playground_kit.dart';
import 'package:entry_ui/widgets/app_chip.dart';
import 'package:entry_ui/widgets/app_filter_chip.dart';
import 'package:entry_ui/widgets/app_info_tag.dart';
import 'package:entry_ui/widgets/app_sold_out_badge.dart';
import 'package:entry_ui/widgets/app_tag.dart';

class PlaygroundTagsTab extends StatefulWidget {
  const PlaygroundTagsTab({super.key});

  @override
  State<PlaygroundTagsTab> createState() => _PlaygroundTagsTabState();
}

class _PlaygroundTagsTabState extends State<PlaygroundTagsTab> {
  final _filters = <String>{'Highest rated'};
  final _people = ['Nominee 1 (50%)', 'Nominee 2 (50%)'];
  int _selectedPerson = 1;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'AppTag — tones (soft)',
          children: [
            CodeDemo(
              code: '''
const AppTag('AAA+', tone: AppTagTone.success)
const AppTag('BB', tone: AppTagTone.caution)
const AppTag('C-', tone: AppTagTone.error)''',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in AppTagTone.values)
                    AppTag(t.name.toUpperCase(), tone: t),
                ],
              ),
            ),
            CodeDemo(
              title: 'Rating scale example',
              code: '''
AppTag(rating, tone: switch (rating[0]) {
  'A' => AppTagTone.success,
  'B' => AppTagTone.caution,
  _ => AppTagTone.error,
})''',
              child: const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag('AAA+', tone: AppTagTone.success),
                  AppTag('AA', tone: AppTagTone.success),
                  AppTag('A-', tone: AppTagTone.success),
                  AppTag('BBB+', tone: AppTagTone.warning),
                  AppTag('BB', tone: AppTagTone.caution),
                  AppTag('B-', tone: AppTagTone.caution),
                  AppTag('CCC', tone: AppTagTone.error),
                  AppTag('C', tone: AppTagTone.error),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppTag — styles',
          children: [
            CodeDemo(
              code: '''
const AppTag('MANUFACTURING', style: AppTagStyle.outlined, tone: AppTagTone.purple)
const AppTag('SELL INSTANTLY', style: AppTagStyle.solid, tone: AppTagTone.warning)
const AppTag('HIGH SAFETY', tone: AppTagTone.success)
const AppTag('BONDS', style: AppTagStyle.outlined, tone: AppTagTone.purple, count: 3)''',
              child: const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AppTag(
                    'MANUFACTURING',
                    style: AppTagStyle.outlined,
                    tone: AppTagTone.purple,
                  ),
                  AppTag(
                    'SELL INSTANTLY',
                    style: AppTagStyle.solid,
                    tone: AppTagTone.warning,
                  ),
                  AppTag('HIGH SAFETY', tone: AppTagTone.success),
                  AppTag(
                    'BONDS',
                    style: AppTagStyle.outlined,
                    tone: AppTagTone.purple,
                    count: 3,
                  ),
                  AppTag(
                    'VERIFIED',
                    tone: AppTagTone.brand,
                    icon: Icons.verified_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppInfoTag',
          children: [
            CodeDemo(
              code:
                  "const AppInfoTag(label: 'Matures on:', value: '03 Jul 25')",
              child: const Align(
                alignment: Alignment.centerLeft,
                child: AppInfoTag(label: 'Matures on:', value: '03 Jul 25'),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppChip',
          children: [
            CodeDemo(
              code: '''
AppChip(
  label: 'Nominee 1 (50%)',
  selected: selected == 0,
  onTap: () => setState(() => selected = 0),
  onRemove: () => remove(0),
)

AppChip.add(label: 'Add nominee', onTap: add)''',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _people.length; i++)
                    AppChip(
                      label: _people[i],
                      selected: i == _selectedPerson,
                      onTap: () => setState(() => _selectedPerson = i),
                      onRemove: i == _selectedPerson
                          ? () => setState(() {
                              _people.removeAt(i);
                              _selectedPerson = -1;
                            })
                          : null,
                    ),
                  AppChip.add(
                    label: 'Add nominee',
                    onTap: () => setState(
                      () => _people.add('Nominee ${_people.length + 1}'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppFilterChip',
          children: [
            CodeDemo(
              code: '''
AppFilterChip(
  label: 'Highest rated',
  selected: filters.contains('Highest rated'),
  onSelected: (v) => setState(
    () => v ? filters.add('Highest rated') : filters.remove('Highest rated'),
  ),
)''',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final f in [
                    'Highest rated',
                    'Short term',
                    'Tax free',
                    'Monthly',
                  ])
                    AppFilterChip(
                      label: f,
                      selected: _filters.contains(f),
                      onSelected: (v) => setState(
                        () => v ? _filters.add(f) : _filters.remove(f),
                      ),
                    ),
                  const AppFilterChip(
                    label: 'Disabled',
                    selected: false,
                    onSelected: null,
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppSoldOutBadge',
          children: [
            CodeDemo(
              code: '''
const AppSoldOutBadge(percent: 50)
const AppSoldOutBadge(percent: 100)''',
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSoldOutBadge(percent: 50),
                  SizedBox(width: 24),
                  AppSoldOutBadge(percent: 100),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
