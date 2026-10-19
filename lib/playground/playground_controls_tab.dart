import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_ui/playground/playground_kit.dart';
import 'package:entry_ui/widgets/app_bookmark_button.dart';
import 'package:entry_ui/widgets/app_button.dart';
import 'package:entry_ui/widgets/app_checkbox.dart';
import 'package:entry_ui/widgets/app_dialog.dart';
import 'package:entry_ui/widgets/app_filter_button.dart';
import 'package:entry_ui/widgets/app_icon_tabs.dart';
import 'package:entry_ui/widgets/app_nav_bar.dart';
import 'package:entry_ui/widgets/app_radio.dart';
import 'package:entry_ui/widgets/app_range_slider.dart';
import 'package:entry_ui/widgets/app_sort_bar.dart';
import 'package:entry_ui/widgets/app_tabs.dart';
import 'package:entry_ui/widgets/app_toast.dart';

class PlaygroundControlsTab extends StatefulWidget {
  const PlaygroundControlsTab({super.key});

  @override
  State<PlaygroundControlsTab> createState() => _PlaygroundControlsTabState();
}

class _PlaygroundControlsTabState extends State<PlaygroundControlsTab> {
  bool _enabled = true;
  bool? _check = true;
  bool _terms = false;
  bool? _all;
  String _method = 'upi';
  int _textTab = 0;
  int _boxTab = 0;
  int _iconTab = 0;
  int _nav = 0;
  int _sort = 0;
  bool _ascending = false;
  RangeValues _range = const RangeValues(6, 12);
  RangeValues _range2 = const RangeValues(0.2, 0.8);
  bool _filterActive = true;
  bool _saved = true;
  bool _savedDark = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PlaygroundPage(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enabled'),
          value: _enabled,
          onChanged: (v) => setState(() => _enabled = v),
        ),
        PlaygroundSection(
          'AppCheckbox',
          children: [
            CodeDemo(
              title: 'Checked / indeterminate / empty',
              code: '''
AppCheckbox(
  value: checked, // null = indeterminate
  onChanged: (v) => setState(() => checked = v),
)''',
              child: Wrap(
                spacing: 16,
                children: [
                  AppCheckbox(
                    value: _check,
                    onChanged: _enabled
                        ? (v) => setState(() => _check = v)
                        : null,
                  ),
                  AppCheckbox(
                    value: _all,
                    onChanged: _enabled
                        ? (_) => setState(
                            () => _all = switch (_all) {
                              null => true,
                              true => false,
                              false => null,
                            },
                          )
                        : null,
                  ),
                  AppCheckbox(
                    value: false,
                    onChanged: _enabled ? (_) {} : null,
                  ),
                ],
              ),
            ),
            CodeDemo(
              title: 'With label / paragraph',
              code: '''
AppCheckbox(
  value: agreed,
  label: 'I agree to the terms and conditions',
  onChanged: (v) => setState(() => agreed = v),
)''',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCheckbox(
                    value: _terms,
                    label: 'Label',
                    onChanged: _enabled
                        ? (v) => setState(() => _terms = v)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  AppCheckbox(
                    value: _terms,
                    label:
                        'I confirm that the details provided are correct and '
                        'I agree to the terms of use and privacy policy.',
                    onChanged: _enabled
                        ? (v) => setState(() => _terms = v)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppRadio',
          children: [
            CodeDemo(
              code: '''
AppRadio<String>(
  value: 'upi',
  groupValue: method,
  label: 'UPI',
  onChanged: (v) => setState(() => method = v),
)''',
              child: Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  for (final (v, l) in [
                    ('upi', 'UPI'),
                    ('cash', 'Cash'),
                    ('card', 'Card'),
                  ])
                    AppRadio<String>(
                      value: v,
                      groupValue: _method,
                      label: l,
                      onChanged: _enabled
                          ? (x) => setState(() => _method = x)
                          : null,
                    ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppTabs',
          children: [
            CodeDemo(
              title: 'Text',
              code: '''
AppTabs(
  tabs: const [AppTab('All'), AppTab('Income'), AppTab('Expense')],
  selectedIndex: index,
  onChanged: (i) => setState(() => index = i),
)''',
              child: AppTabs(
                padding: EdgeInsets.zero,
                tabs: const [
                  AppTab('All'),
                  AppTab('Income'),
                  AppTab('Expense'),
                  AppTab('Transfers'),
                ],
                selectedIndex: _textTab,
                onChanged: (i) => setState(() => _textTab = i),
              ),
            ),
            CodeDemo(
              title: 'Boxed with filter + icons',
              code: '''
AppTabs(
  style: AppTabsStyle.boxed,
  leading: AppFilterButton(isActive: hasFilters, onPressed: openFilters),
  tabs: const [
    AppTab('Saved', icon: Icons.bookmark_rounded),
    AppTab('Recent'),
    AppTab('Popular'),
  ],
  selectedIndex: index,
  onChanged: (i) => setState(() => index = i),
)''',
              child: AppTabs(
                style: AppTabsStyle.boxed,
                padding: EdgeInsets.zero,
                leading: AppFilterButton(
                  isActive: _filterActive,
                  onPressed: () =>
                      setState(() => _filterActive = !_filterActive),
                ),
                tabs: const [
                  AppTab('Saved', icon: Icons.bookmark_rounded),
                  AppTab('Recent'),
                  AppTab('Popular'),
                  AppTab('Upcoming'),
                ],
                selectedIndex: _boxTab,
                onChanged: (i) => setState(() => _boxTab = i),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppIconTabs',
          children: [
            CodeDemo(
              code: '''
AppIconTabs(
  tabs: const [
    AppIconTab(icon: Icons.apartment_rounded, label: 'Corporate'),
    AppIconTab(icon: Icons.account_balance_outlined, label: 'Govt'),
    AppIconTab(icon: Icons.savings_outlined, label: 'Savings'),
  ],
  selectedIndex: index,
  onChanged: (i) => setState(() => index = i),
)''',
              child: AppIconTabs(
                padding: EdgeInsets.zero,
                tabs: const [
                  AppIconTab(icon: Icons.apartment_rounded, label: 'Corporate'),
                  AppIconTab(
                    icon: Icons.account_balance_outlined,
                    label: 'Govt',
                  ),
                  AppIconTab(icon: Icons.savings_outlined, label: 'Savings'),
                  AppIconTab(icon: Icons.paid_outlined, label: 'Tax free'),
                ],
                selectedIndex: _iconTab,
                onChanged: (i) => setState(() => _iconTab = i),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppNavBar',
          children: [
            CodeDemo(
              code: '''
Scaffold(
  bottomNavigationBar: AppNavBar(
    items: const [
      AppNavItem(icon: Icons.space_dashboard_outlined, label: 'Dashboard'),
      AppNavItem(icon: Icons.work_outline_rounded, label: 'Portfolio'),
      AppNavItem(
        icon: Icons.workspace_premium_outlined,
        label: 'Club',
        gradient: LinearGradient(colors: [Color(0xFFC79A3B), Color(0xFFF2D488)]),
      ),
      AppNavItem(icon: Icons.menu_rounded, label: 'More'),
    ],
    currentIndex: index,
    onTap: (i) => setState(() => index = i),
  ),
)''',
              child: AppNavBar(
                items: const [
                  AppNavItem(
                    icon: Icons.space_dashboard_outlined,
                    label: 'Dashboard',
                  ),
                  AppNavItem(
                    icon: Icons.work_outline_rounded,
                    label: 'Portfolio',
                  ),
                  AppNavItem(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Club',
                    gradient: LinearGradient(
                      colors: [Color(0xFFC79A3B), Color(0xFFF2D488)],
                    ),
                  ),
                  AppNavItem(icon: Icons.menu_rounded, label: 'More'),
                ],
                currentIndex: _nav,
                onTap: (i) => setState(() => _nav = i),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppSortBar',
          children: [
            CodeDemo(
              code: '''
AppSortBar(
  labels: const ['Amount', 'Date', 'Name'],
  selectedIndex: sortIndex,
  ascending: ascending,
  onChanged: (i, asc) => setState(() {
    sortIndex = i;
    ascending = asc;
  }),
)''',
              child: AppSortBar(
                labels: const ['Amount', 'Date', 'Name'],
                selectedIndex: _sort,
                ascending: _ascending,
                onChanged: (i, asc) => setState(() {
                  _sort = i;
                  _ascending = asc;
                }),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppRangeSlider',
          children: [
            CodeDemo(
              title: 'With values',
              code: '''
AppRangeSlider(
  min: 0,
  max: 20,
  divisions: 20,
  values: range,
  showValues: true,
  format: (v) => '\${v.round()}%',
  onChanged: (r) => setState(() => range = r),
)''',
              child: AppRangeSlider(
                min: 0,
                max: 20,
                divisions: 20,
                values: _range,
                showValues: true,
                format: (v) => '${v.round()}%',
                onChanged: (r) => setState(() => _range = r),
              ),
            ),
            CodeDemo(
              title: 'Plain',
              code: '''
AppRangeSlider(
  values: range,
  onChanged: (r) => setState(() => range = r),
)''',
              child: AppRangeSlider(
                values: _range2,
                format: (v) => v.toStringAsFixed(2),
                onChanged: (r) => setState(() => _range2 = r),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppFilterButton & AppBookmarkButton',
          children: [
            CodeDemo(
              code: '''
AppFilterButton(isActive: hasFilters, onPressed: openFilters)

AppBookmarkButton(
  isSaved: saved,
  onChanged: (v) => setState(() => saved = v),
)

// On dark / image backgrounds
AppBookmarkButton(isSaved: saved, onDarkBackground: true, onChanged: toggle)''',
              child: Row(
                children: [
                  AppFilterButton(
                    isActive: _filterActive,
                    onPressed: () =>
                        setState(() => _filterActive = !_filterActive),
                  ),
                  const SizedBox(width: 16),
                  AppFilterButton(onPressed: () {}),
                  const SizedBox(width: 24),
                  AppBookmarkButton(
                    isSaved: _saved,
                    onChanged: (v) => setState(() => _saved = v),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.inverseSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppBookmarkButton(
                      isSaved: _savedDark,
                      onDarkBackground: true,
                      onChanged: (v) => setState(() => _savedDark = v),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppToast',
          children: [
            CodeDemo(
              code: '''
AppToast.show('Entry saved');
AppToast.show('Something went wrong', type: AppToastType.negative);''',
              child: Column(
                children: [
                  const AppToast(message: 'Entry saved successfully'),
                  const SizedBox(height: 8),
                  const AppToast(
                    message: 'Something went wrong',
                    type: AppToastType.negative,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Show positive',
                          variant: AppButtonVariant.secondary,
                          size: AppButtonSize.compact,
                          onPressed: () => AppToast.show('Entry saved'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          label: 'Show negative',
                          variant: AppButtonVariant.secondary,
                          size: AppButtonSize.compact,
                          onPressed: () => AppToast.show(
                            'Something went wrong',
                            type: AppToastType.negative,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppDialog',
          children: [
            CodeDemo(
              title: 'Standard / destructive',
              code: '''
final ok = await AppDialog.show<bool>(
  icon: Icons.person_add_alt_outlined,
  title: 'Add a nominee',
  message: 'Do you want to add Nominee 2?',
  actions: [
    AppButton(
      label: 'Cancel',
      variant: AppButtonVariant.secondary,
      onPressed: () => Get.back(result: false),
    ),
    AppButton(label: 'Add nominee', onPressed: () => Get.back(result: true)),
  ],
);

await AppDialog.show<bool>(
  icon: Icons.delete_outline_rounded,
  iconColor: Theme.of(context).colorScheme.error,
  title: 'Delete nominee',
  message: 'Do you want to delete Nominee 2?',
  actions: [
    AppButton(
      label: 'Cancel',
      variant: AppButtonVariant.secondary,
      onPressed: () => Get.back(result: false),
    ),
    AppButton(
      label: 'Delete',
      variant: AppButtonVariant.destructive,
      onPressed: () => Get.back(result: true),
    ),
  ],
);''',
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Standard',
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.compact,
                      onPressed: () => AppDialog.show<bool>(
                        icon: Icons.person_add_alt_outlined,
                        title: 'Add a nominee',
                        message: 'Do you want to add Nominee 2?',
                        actions: [
                          AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.secondary,
                            onPressed: () => Get.back(result: false),
                          ),
                          AppButton(
                            label: 'Add nominee',
                            onPressed: () => Get.back(result: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      label: 'Destructive',
                      variant: AppButtonVariant.destructive,
                      size: AppButtonSize.compact,
                      onPressed: () => AppDialog.show<bool>(
                        icon: Icons.delete_outline_rounded,
                        iconColor: scheme.error,
                        title: 'Delete nominee',
                        message: 'Do you want to delete Nominee 2?',
                        actions: [
                          AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.secondary,
                            onPressed: () => Get.back(result: false),
                          ),
                          AppButton(
                            label: 'Delete',
                            variant: AppButtonVariant.destructive,
                            onPressed: () => Get.back(result: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
