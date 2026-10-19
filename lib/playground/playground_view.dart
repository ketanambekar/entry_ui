import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/playground/playground_cards_tab.dart';
import 'package:entry_ui/playground/playground_controls_tab.dart';
import 'package:entry_ui/playground/playground_icons_tab.dart';
import 'package:entry_ui/playground/playground_kit.dart';
import 'package:entry_ui/playground/playground_tags_tab.dart';
import 'package:entry_ui/theme/theme_controller.dart';
import 'package:entry_ui/widgets/app_button.dart';
import 'package:entry_ui/widgets/app_dropdown.dart';
import 'package:entry_ui/widgets/app_input.dart';
import 'package:entry_ui/widgets/app_otp.dart';

/// Developer playground to visually check the design system:
/// theme mode, typography, colours, buttons and common Material widgets.
class PlaygroundView extends StatelessWidget {
  const PlaygroundView({super.key});

  static const _tabs = [
    'Theme',
    'Typography',
    'Colors',
    'Buttons',
    'Inputs',
    'Controls',
    'Tags',
    'Cards',
    'Icons',
    'Widgets',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Playground'),
          actions: [
            Obx(() {
              final controller = ThemeController.to;
              controller.themeMode; // Rebuild when the mode changes.
              return IconButton(
                tooltip: 'Toggle theme',
                icon: Icon(
                  controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: controller.toggleTheme,
              );
            }),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final tab in _tabs) Tab(text: tab)],
          ),
        ),
        body: const TabBarView(
          children: [
            _ThemeTab(),
            _TypographyTab(),
            _ColorsTab(),
            _ButtonsTab(),
            _InputsTab(),
            PlaygroundControlsTab(),
            PlaygroundTagsTab(),
            PlaygroundCardsTab(),
            PlaygroundIconsTab(),
            _WidgetsTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

class _ThemeTab extends StatelessWidget {
  const _ThemeTab();

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.to;
    final scheme = Theme.of(context).colorScheme;
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'Theme mode',
          children: [
            Obx(
              () => SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.brightness_auto),
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode),
                    label: Text('Dark'),
                  ),
                ],
                selected: {controller.themeMode},
                onSelectionChanged: (s) => controller.setThemeMode(s.first),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'Saved mode: ${controller.themeMode.name} · '
                'showing: ${controller.isDarkMode ? 'dark' : 'light'}',
                style: AppTextStyles.bodyS,
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'Color scheme',
          children: [
            const _CopyHint(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Swatch(
                  'primary',
                  scheme.primary,
                  code: 'Theme.of(context).colorScheme.primary',
                ),
                _Swatch(
                  'onPrimary',
                  scheme.onPrimary,
                  code: 'Theme.of(context).colorScheme.onPrimary',
                ),
                _Swatch(
                  'primaryContainer',
                  scheme.primaryContainer,
                  code: 'Theme.of(context).colorScheme.primaryContainer',
                ),
                _Swatch(
                  'secondary',
                  scheme.secondary,
                  code: 'Theme.of(context).colorScheme.secondary',
                ),
                _Swatch(
                  'secondaryContainer',
                  scheme.secondaryContainer,
                  code: 'Theme.of(context).colorScheme.secondaryContainer',
                ),
                _Swatch(
                  'tertiary',
                  scheme.tertiary,
                  code: 'Theme.of(context).colorScheme.tertiary',
                ),
                _Swatch(
                  'error',
                  scheme.error,
                  code: 'Theme.of(context).colorScheme.error',
                ),
                _Swatch(
                  'errorContainer',
                  scheme.errorContainer,
                  code: 'Theme.of(context).colorScheme.errorContainer',
                ),
                _Swatch(
                  'surface',
                  scheme.surface,
                  code: 'Theme.of(context).colorScheme.surface',
                ),
                _Swatch(
                  'onSurface',
                  scheme.onSurface,
                  code: 'Theme.of(context).colorScheme.onSurface',
                ),
                _Swatch(
                  'onSurfaceVariant',
                  scheme.onSurfaceVariant,
                  code: 'Theme.of(context).colorScheme.onSurfaceVariant',
                ),
                _Swatch(
                  'outline',
                  scheme.outline,
                  code: 'Theme.of(context).colorScheme.outline',
                ),
                _Swatch(
                  'outlineVariant',
                  scheme.outlineVariant,
                  code: 'Theme.of(context).colorScheme.outlineVariant',
                ),
                _Swatch(
                  'scaffold',
                  Theme.of(context).scaffoldBackgroundColor,
                  code: 'Theme.of(context).scaffoldBackgroundColor',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Typography
// ---------------------------------------------------------------------------

class _TypographyTab extends StatefulWidget {
  const _TypographyTab();

  @override
  State<_TypographyTab> createState() => _TypographyTabState();
}

class _TypographyTabState extends State<_TypographyTab> {
  FontWeight _weight = FontWeight.w400;
  final _sampleController = TextEditingController(
    text: 'The quick brown fox jumps',
  );

  String get _sample => _sampleController.text;

  static final _weightSuffix = {
    FontWeight.w400: '',
    FontWeight.w500: '.medium',
    FontWeight.w600: '.semiBold',
    FontWeight.w700: '.bold',
  };

  @override
  void dispose() {
    _sampleController.dispose();
    super.dispose();
  }

  static final _styles = <(String, String, TextStyle, String)>[
    (
      'Display L',
      'displayL',
      AppTextStyles.displayL,
      '32 · Banana Grotesk · 120%',
    ),
    (
      'Display M',
      'displayM',
      AppTextStyles.displayM,
      '28 · Banana Grotesk · 120%',
    ),
    (
      'Display S',
      'displayS',
      AppTextStyles.displayS,
      '24 · Banana Grotesk · 120%',
    ),
    (
      'Display T',
      'displayT',
      AppTextStyles.displayT,
      '22 · Banana Grotesk · 120%',
    ),
    (
      'Subtitle L',
      'subtitleL',
      AppTextStyles.subtitleL,
      '20 · Banana Grotesk · 130%',
    ),
    ('Subtitle M', 'subtitleM', AppTextStyles.subtitleM, '18 · Manrope · 130%'),
    ('Subtitle S', 'subtitleS', AppTextStyles.subtitleS, '16 · Manrope · 140%'),
    (
      'Subtitle XS',
      'subtitleXS',
      AppTextStyles.subtitleXS,
      '15 · Manrope · 140%',
    ),
    ('Body L', 'bodyL', AppTextStyles.bodyL, '14 · Manrope · 140%'),
    ('Body M', 'bodyM', AppTextStyles.bodyM, '13 · Manrope · 130%'),
    ('Body S', 'bodyS', AppTextStyles.bodyS, '12 · Manrope · 140%'),
    ('Body T', 'bodyT', AppTextStyles.bodyT, '11 · Manrope · 140%'),
    ('CAPS', 'caps', AppTextStyles.caps, '12 · Manrope · uppercase'),
    ('CAPS T', 'capsT', AppTextStyles.capsT, '11 · Manrope · uppercase'),
  ];

  String _textCode(String key) {
    final text = key.startsWith('caps') ? _sample.toUpperCase() : _sample;
    final escaped = text.replaceAll('\\', '\\\\').replaceAll("'", r"\'");
    return "Text('$escaped', style: AppTextStyles.$key${_weightSuffix[_weight]})";
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'Weight',
          children: [
            SegmentedButton<FontWeight>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: FontWeight.w400, label: Text('Regular')),
                ButtonSegment(value: FontWeight.w500, label: Text('Medium')),
                ButtonSegment(value: FontWeight.w600, label: Text('Semi')),
                ButtonSegment(value: FontWeight.w700, label: Text('Bold')),
              ],
              selected: {_weight},
              onSelectionChanged: (s) => setState(() => _weight = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Sample text',
                border: OutlineInputBorder(),
              ),
              controller: _sampleController,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
        PlaygroundSection(
          'Type scale',
          children: [
            Text(
              'Copy gives a ready Text widget with the selected weight',
              style: AppTextStyles.bodyS.copyWith(color: muted),
            ),
            const SizedBox(height: 8),
            for (final (name, key, style, spec) in _styles)
              CodeDemo(
                title: '$name · $spec',
                code: _textCode(key),
                child: Text(
                  key.startsWith('caps') ? _sample.toUpperCase() : _sample,
                  style: style.copyWith(fontWeight: _weight),
                ),
              ),
          ],
        ),
        PlaygroundSection(
          'Default text (theme)',
          children: const [
            Text('Plain Text widget — uses the theme default (Body L).'),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------

typedef _ColorGroup = (String, List<(String, Color)>);

List<_ColorGroup> _lightPalette() => const [
  (
    'Brand',
    [
      ('primary25', AppColors.primary25),
      ('primary50', AppColors.primary50),
      ('primary100', AppColors.primary100),
      ('primary300', AppColors.primary300),
      ('primary', AppColors.primary),
      ('primary600', AppColors.primary600),
      ('primary800', AppColors.primary800),
      ('primary900', AppColors.primary900),
    ],
  ),
  (
    'Accent',
    [
      ('accent50', AppColors.accent50),
      ('accent100', AppColors.accent100),
      ('accent', AppColors.accent),
      ('accent600', AppColors.accent600),
    ],
  ),
  (
    'Neutrals',
    [
      ('white', AppColors.white),
      ('surface', AppColors.surface),
      ('grey25', AppColors.grey25),
      ('grey50', AppColors.grey50),
      ('grey100', AppColors.grey100),
      ('grey200', AppColors.grey200),
      ('grey400', AppColors.grey400),
      ('grey500', AppColors.grey500),
      ('grey550', AppColors.grey550),
      ('grey600', AppColors.grey600),
      ('grey800', AppColors.grey800),
    ],
  ),
  (
    'Yellow',
    [
      ('yellow100', AppColors.yellow100),
      ('yellow500', AppColors.yellow500),
      ('yellow800', AppColors.yellow800),
    ],
  ),
  (
    'Success',
    [
      ('success25', AppColors.success25),
      ('success50', AppColors.success50),
      ('success100', AppColors.success100),
      ('success', AppColors.success),
      ('success600', AppColors.success600),
    ],
  ),
  (
    'Error',
    [
      ('error50', AppColors.error50),
      ('error', AppColors.error),
      ('error600', AppColors.error600),
    ],
  ),
  (
    'Charts',
    [
      ('chartSky', AppColors.chartSky),
      ('chartViolet', AppColors.chartViolet),
      ('chartPink', AppColors.chartPink),
      ('chartTeal', AppColors.chartTeal),
      ('chartOrange', AppColors.chartOrange),
      ('chartAmber', AppColors.chartAmber),
    ],
  ),
];

List<_ColorGroup> _darkPalette() => const [
  (
    'Brand',
    [
      ('primary25', AppDarkColors.primary25),
      ('primary50', AppDarkColors.primary50),
      ('primary100', AppDarkColors.primary100),
      ('primary300', AppDarkColors.primary300),
      ('primary', AppDarkColors.primary),
      ('primary600', AppDarkColors.primary600),
      ('primary800', AppDarkColors.primary800),
      ('primary900', AppDarkColors.primary900),
    ],
  ),
  (
    'Accent',
    [
      ('accent50', AppDarkColors.accent50),
      ('accent100', AppDarkColors.accent100),
      ('accent', AppDarkColors.accent),
      ('accent600', AppDarkColors.accent600),
    ],
  ),
  (
    'Neutrals',
    [
      ('white', AppDarkColors.white),
      ('surface', AppDarkColors.surface),
      ('grey25', AppDarkColors.grey25),
      ('grey50', AppDarkColors.grey50),
      ('grey100', AppDarkColors.grey100),
      ('grey200', AppDarkColors.grey200),
      ('grey400', AppDarkColors.grey400),
      ('grey500', AppDarkColors.grey500),
      ('grey550', AppDarkColors.grey550),
      ('grey600', AppDarkColors.grey600),
      ('grey800', AppDarkColors.grey800),
    ],
  ),
  (
    'Yellow',
    [
      ('yellow100', AppDarkColors.yellow100),
      ('yellow500', AppDarkColors.yellow500),
      ('yellow800', AppDarkColors.yellow800),
    ],
  ),
  (
    'Success',
    [
      ('success25', AppDarkColors.success25),
      ('success50', AppDarkColors.success50),
      ('success100', AppDarkColors.success100),
      ('success', AppDarkColors.success),
      ('success600', AppDarkColors.success600),
    ],
  ),
  (
    'Error',
    [
      ('error50', AppDarkColors.error50),
      ('error', AppDarkColors.error),
      ('error600', AppDarkColors.error600),
    ],
  ),
  (
    'Charts',
    [
      ('chartSky', AppDarkColors.chartSky),
      ('chartViolet', AppDarkColors.chartViolet),
      ('chartPink', AppDarkColors.chartPink),
      ('chartTeal', AppDarkColors.chartTeal),
      ('chartOrange', AppDarkColors.chartOrange),
      ('chartAmber', AppDarkColors.chartAmber),
    ],
  ),
];

class _ColorsTab extends StatelessWidget {
  const _ColorsTab();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final groups = dark ? _darkPalette() : _lightPalette();
    final tags = dark
        ? const [
            ('Blue', AppDarkColors.tagBlue),
            ('Amber', AppDarkColors.tagAmber),
            ('Orange', AppDarkColors.tagOrange),
            ('Red', AppDarkColors.tagRed),
            ('Purple', AppDarkColors.tagPurple),
            ('Green', AppDarkColors.tagGreen),
            ('Grey', AppDarkColors.tagGrey),
          ]
        : const [
            ('Blue', AppColors.tagBlue),
            ('Amber', AppColors.tagAmber),
            ('Orange', AppColors.tagOrange),
            ('Red', AppColors.tagRed),
            ('Purple', AppColors.tagPurple),
            ('Green', AppColors.tagGreen),
            ('Grey', AppColors.tagGrey),
          ];
    final palette = dark ? 'AppDarkColors' : 'AppColors';
    return PlaygroundPage(
      children: [
        Text(palette, style: AppTextStyles.subtitleM.bold),
        const SizedBox(height: 4),
        const _CopyHint(),
        const SizedBox(height: 12),
        for (final (title, colors) in groups)
          PlaygroundSection(
            title,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (name, color) in colors)
                    _Swatch(name, color, code: '$palette.$name'),
                ],
              ),
            ],
          ),
        PlaygroundSection(
          'Tags',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (name, tag) in tags)
                  _Copyable(
                    code: '$palette.tag$name',
                    hex: _hex(tag.fill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tag.fill,
                        border: Border.all(color: tag.stroke),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        name.toUpperCase(),
                        style: AppTextStyles.capsT.semiBold.copyWith(
                          color: tag.text,
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

String _hex(Color color) =>
    '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

class _CopyHint extends StatelessWidget {
  const _CopyHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        'Tap to copy the constant · long-press to copy the Color(0x…) value',
        style: AppTextStyles.bodyS.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Copyable extends StatelessWidget {
  const _Copyable({required this.code, required this.hex, required this.child});

  final String code;
  final String hex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: code,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => copyToClipboard(code, label: code),
        onLongPress: () {
          final value = 'const Color(0xFF${hex.substring(1)})';
          copyToClipboard(value, label: value);
        },
        child: child,
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color, {required this.code});

  final String name;
  final Color color;
  final String code;

  @override
  Widget build(BuildContext context) {
    final hex = _hex(color);
    final onColor = color.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
    return _Copyable(
      code: code,
      hex: hex,
      child: Container(
        width: 104,
        height: 72,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyT.semiBold.copyWith(color: onColor),
            ),
            Text(hex, style: AppTextStyles.bodyT.copyWith(color: onColor)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------

class _ButtonsTab extends StatefulWidget {
  const _ButtonsTab();

  @override
  State<_ButtonsTab> createState() => _ButtonsTabState();
}

class _ButtonsTabState extends State<_ButtonsTab> {
  AppButtonSize _size = AppButtonSize.medium;
  bool _enabled = true;
  bool _loading = false;

  String _variantCode(AppButtonVariant v) {
    final variant = v == AppButtonVariant.primary
        ? ''
        : '\n  variant: AppButtonVariant.${v.name},';
    final size = _size == AppButtonSize.medium
        ? ''
        : '\n  size: AppButtonSize.${_size.name},';
    return '''
AppButton(
  label: 'Button',$variant$size
  onPressed: () {},
)

AppButton(
  label: 'Leading',$variant$size
  leading: const Icon(Icons.add),
  onPressed: () {},
)

AppButton.icon(
  icon: const Icon(Icons.arrow_forward),
  semanticLabel: 'Next',$variant$size
  onPressed: () {},
)
''';
  }

  Future<void> _fakeRequest() =>
      Future<void>.delayed(const Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    final onPressed = _enabled ? () {} : null;
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'Controls',
          children: [
            SegmentedButton<AppButtonSize>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: AppButtonSize.compact,
                  label: Text('Compact'),
                ),
                ButtonSegment(
                  value: AppButtonSize.medium,
                  label: Text('Medium'),
                ),
                ButtonSegment(value: AppButtonSize.large, label: Text('Large')),
              ],
              selected: {_size},
              onSelectionChanged: (s) => setState(() => _size = s.first),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enabled'),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Loading'),
              value: _loading,
              onChanged: (v) => setState(() => _loading = v),
            ),
          ],
        ),
        for (final variant in AppButtonVariant.values)
          PlaygroundSection(
            variant.name,
            children: [
              CodeDemo(
                code: _variantCode(variant),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppButton(
                      label: 'Button',
                      variant: variant,
                      size: _size,
                      isLoading: _loading,
                      onPressed: onPressed,
                    ),
                    AppButton(
                      label: 'Leading',
                      variant: variant,
                      size: _size,
                      isLoading: _loading,
                      leading: const Icon(Icons.add),
                      onPressed: onPressed,
                    ),
                    AppButton(
                      label: 'Trailing',
                      variant: variant,
                      size: _size,
                      isLoading: _loading,
                      trailing: const Icon(Icons.arrow_forward),
                      onPressed: onPressed,
                    ),
                    AppButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      semanticLabel: 'Next',
                      variant: variant,
                      size: _size,
                      isLoading: _loading,
                      onPressed: onPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        PlaygroundSection(
          'Full width',
          children: [
            CodeDemo(
              code: '''
AppButton(
  label: 'Continue',
  expanded: true,
  onPressed: () {},
)

Row(
  children: [
    Expanded(
      child: AppButton(
        label: 'Cancel',
        variant: AppButtonVariant.secondary,
        expanded: true,
        onPressed: () {},
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: AppButton(label: 'Confirm', expanded: true, onPressed: () {}),
    ),
  ],
)
''',
              child: Column(
                children: [
                  AppButton(
                    label: 'Continue',
                    size: _size,
                    expanded: true,
                    isLoading: _loading,
                    onPressed: onPressed,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          variant: AppButtonVariant.secondary,
                          size: _size,
                          expanded: true,
                          onPressed: onPressed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: 'Confirm',
                          size: _size,
                          expanded: true,
                          onPressed: onPressed,
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
          'Async (tap me — 2s loader)',
          children: [
            CodeDemo(
              code: '''
// Returning a Future shows the loader until it completes.
AppButton(
  label: 'Save',
  leading: const Icon(Icons.save_outlined),
  onPressed: () async => await controller.save(),
)
''',
              child: AppButton(
                label: 'Save',
                size: _size,
                leading: const Icon(Icons.save_outlined),
                onPressed: _enabled ? _fakeRequest : null,
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'Long label',
          children: [
            SizedBox(
              width: 200,
              child: AppButton(
                label: 'A very long label that should be truncated nicely',
                size: _size,
                trailing: const Icon(Icons.arrow_forward),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Inputs
// ---------------------------------------------------------------------------

class _InputsTab extends StatefulWidget {
  const _InputsTab();

  @override
  State<_InputsTab> createState() => _InputsTabState();
}

class _InputsTabState extends State<_InputsTab> {
  static const _genders = [
    AppDropdownItem(value: 'female', label: 'Female'),
    AppDropdownItem(value: 'male', label: 'Male'),
    AppDropdownItem(value: 'other', label: 'Other'),
    AppDropdownItem(value: 'none', label: 'Prefer not to say', enabled: false),
  ];

  final _formKey = GlobalKey<FormState>();
  bool _enabled = true;
  bool _required = true;
  bool _showErrors = false;
  String? _gender;
  String? _formGender;

  String? get _error => _showErrors ? 'Incorrect OTP detected*' : null;

  void _toast(String message) => Get.snackbar(
    'Playground',
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
  );

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'Controls',
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enabled'),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mandatory (*)'),
              value: _required,
              onChanged: (v) => setState(() => _required = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show errors'),
              value: _showErrors,
              onChanged: (v) => setState(() => _showErrors = v),
            ),
          ],
        ),
        PlaygroundSection(
          'AppInput',
          children: [
            CodeDemo(
              code: r'''
AppInput(
  label: 'User ID',
  hint: 'eg. kevinabc',
  isRequired: true,
  controller: userIdController,
)
''',
              child: AppInput(
                label: 'User ID',
                hint: 'eg. kevinabc',
                isRequired: _required,
                enabled: _enabled,
                errorText: _error,
              ),
            ),
            const SizedBox(height: 16),
            CodeDemo(
              code: r'''
AppInput(
  label: 'Password',
  hint: 'Enter password',
  obscureText: true,
  isRequired: true,
  controller: passwordController,
)
''',
              child: AppInput(
                label: 'Password',
                hint: 'Enter password',
                initialValue: 'secret123',
                obscureText: true,
                isRequired: _required,
                enabled: _enabled,
                errorText: _error,
              ),
            ),
            const SizedBox(height: 16),
            CodeDemo(
              code: r'''
AppInput(
  label: 'Search',
  hint: 'Search entries',
  prefixIcon: const Icon(Icons.search),
  helperText: 'Helper text sits below the field.',
  textInputAction: TextInputAction.search,
  onChanged: (v) => controller.search(v),
)
''',
              child: AppInput(
                label: 'Search',
                hint: 'Search entries',
                prefixIcon: const Icon(Icons.search),
                helperText: 'Helper text sits below the field.',
                enabled: _enabled,
                textInputAction: TextInputAction.search,
              ),
            ),
            const SizedBox(height: 16),
            CodeDemo(
              code: r'''
AppInput(
  label: 'Notes',
  hint: 'Multi-line input',
  minLines: 3,
  maxLines: 4,
)
''',
              child: AppInput(
                label: 'Notes',
                hint: 'Multi-line input',
                maxLines: 4,
                minLines: 3,
                enabled: _enabled,
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppDropdown',
          children: [
            CodeDemo(
              code: r'''
AppDropdown<String>(
  label: 'Select your gender',
  hint: 'Choose from list',
  isRequired: true,
  value: gender,
  items: const [
    AppDropdownItem(value: 'female', label: 'Female'),
    AppDropdownItem(value: 'male', label: 'Male'),
    AppDropdownItem(value: 'other', label: 'Other'),
  ],
  onChanged: (v) => setState(() => gender = v),
)
''',
              child: AppDropdown<String>(
                label: 'Select your gender',
                hint: 'Choose from list',
                isRequired: _required,
                enabled: _enabled,
                errorText: _error,
                value: _gender,
                items: _genders,
                onChanged: (v) => setState(() => _gender = v),
              ),
            ),
            const SizedBox(height: 16),
            AppDropdown<int>(
              label: 'Long list (scrolls)',
              hint: 'Pick a number',
              enabled: _enabled,
              items: [
                for (var i = 1; i <= 20; i++)
                  AppDropdownItem(value: i, label: 'Option $i'),
              ],
              onChanged: (v) => _toast('Picked option $v'),
            ),
          ],
        ),
        PlaygroundSection(
          'AppOtp',
          children: [
            CodeDemo(
              code: r'''
AppOtp(
  label: 'Enter OTP',
  isRequired: true,
  onCompleted: (code) => controller.verify(code),
)
''',
              child: AppOtp(
                label: 'Enter OTP',
                isRequired: _required,
                enabled: _enabled,
                errorText: _error,
                onCompleted: (code) => _toast('OTP entered: $code'),
              ),
            ),
            const SizedBox(height: 16),
            CodeDemo(
              code: r'''
AppOtp(label: 'Secure PIN', secure: true, onCompleted: unlock)
''',
              child: AppOtp(
                label: 'Secure PIN',
                secure: true,
                enabled: _enabled,
                errorText: _error,
              ),
            ),
            const SizedBox(height: 16),
            CodeDemo(
              code: r'''
AppOtp(label: '6-digit code', length: 6)
''',
              child: AppOtp(
                label: '6-digit code',
                length: 6,
                enabled: _enabled,
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'Form validation',
          children: [
            CodeDemo(
              code: r'''
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: Column(
    children: [
      AppInput(
        label: 'Email',
        hint: 'name@example.com',
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        validator: (v) =>
            (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
      ),
      const SizedBox(height: 16),
      AppOtp(
        label: 'OTP',
        isRequired: true,
        validator: (v) => (v ?? '').length < 4 ? 'Enter all 4 digits' : null,
      ),
      const SizedBox(height: 24),
      AppButton(
        label: 'Submit',
        expanded: true,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // submit
          }
        },
      ),
    ],
  ),
)
''',
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppInput(
                      label: 'Email',
                      hint: 'name@example.com',
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppDropdown<String>(
                      label: 'Gender',
                      hint: 'Choose from list',
                      isRequired: true,
                      items: _genders,
                      value: _formGender,
                      onChanged: (v) => setState(() => _formGender = v),
                      validator: (v) => v == null ? 'Please choose one' : null,
                    ),
                    const SizedBox(height: 16),
                    AppOtp(
                      label: 'OTP',
                      isRequired: true,
                      validator: (v) =>
                          (v ?? '').length < 4 ? 'Enter all 4 digits' : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Reset',
                            variant: AppButtonVariant.tertiary,
                            onPressed: () {
                              _formKey.currentState!.reset();
                              setState(() => _formGender = null);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Submit',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _toast('Form is valid');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WidgetsTab extends StatefulWidget {
  const _WidgetsTab();

  @override
  State<_WidgetsTab> createState() => _WidgetsTabState();
}

class _WidgetsTabState extends State<_WidgetsTab> {
  bool _checked = true;
  bool _switched = true;
  double _slider = 0.4;
  String _radio = 'Cash';
  final Set<String> _chips = {'Food'};

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'Text fields',
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Label',
                hintText: 'Hint text',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'With error',
                errorText: 'This field is required',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Disabled',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'Selection controls',
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Checkbox'),
              value: _checked,
              onChanged: (v) => setState(() => _checked = v ?? false),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Switch'),
              value: _switched,
              onChanged: (v) => setState(() => _switched = v),
            ),
            RadioGroup<String>(
              groupValue: _radio,
              onChanged: (v) => setState(() => _radio = v ?? _radio),
              child: const Column(
                children: [
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Cash'),
                    value: 'Cash',
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('UPI'),
                    value: 'UPI',
                  ),
                ],
              ),
            ),
            Slider(
              value: _slider,
              onChanged: (v) => setState(() => _slider = v),
            ),
          ],
        ),
        PlaygroundSection(
          'Chips',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in ['Food', 'Travel', 'Bills', 'Shopping'])
                  FilterChip(
                    label: Text(label),
                    selected: _chips.contains(label),
                    onSelected: (v) => setState(
                      () => v ? _chips.add(label) : _chips.remove(label),
                    ),
                  ),
                const Chip(label: Text('Chip'), avatar: Icon(Icons.tag)),
              ],
            ),
          ],
        ),
        PlaygroundSection(
          'Cards & lists',
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card title', style: AppTextStyles.subtitleM.semiBold),
                    const SizedBox(height: 4),
                    Text(
                      'Supporting text inside a card using Body S.',
                      style: AppTextStyles.bodyS.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                child: Icon(Icons.receipt_long, color: scheme.primary),
              ),
              title: const Text('List tile title'),
              subtitle: const Text('Subtitle text'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
        PlaygroundSection(
          'Progress',
          children: const [
            LinearProgressIndicator(value: 0.6),
            SizedBox(height: 16),
            Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                CircularProgressIndicator(value: 0.7),
              ],
            ),
          ],
        ),
        PlaygroundSection(
          'Overlays',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(
                  label: 'Snackbar',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.compact,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Entry saved'),
                      action: SnackBarAction(label: 'Undo', onPressed: () {}),
                    ),
                  ),
                ),
                AppButton(
                  label: 'Dialog',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.compact,
                  onPressed: () => Get.dialog<void>(
                    AlertDialog(
                      title: const Text('Delete entry?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        AppButton(
                          label: 'Cancel',
                          variant: AppButtonVariant.link,
                          onPressed: Get.back<void>,
                        ),
                        AppButton(
                          label: 'Delete',
                          variant: AppButtonVariant.destructive,
                          onPressed: Get.back<void>,
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  label: 'Bottom sheet',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.compact,
                  onPressed: () => Get.bottomSheet<void>(
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bottom sheet',
                              style: AppTextStyles.subtitleL.semiBold,
                            ),
                            const SizedBox(height: 8),
                            const Text('Content goes here.'),
                            const SizedBox(height: 16),
                            AppButton(
                              label: 'Close',
                              expanded: true,
                              onPressed: Get.back<void>,
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: scheme.surface,
                  ),
                ),
              ],
            ),
          ],
        ),
        PlaygroundSection(
          'Navigation',
          children: [
            NavigationBar(
              selectedIndex: 0,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
