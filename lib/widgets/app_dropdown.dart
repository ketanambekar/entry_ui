import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// One option of an [AppDropdown].
@immutable
class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// Design-system dropdown: same look as [AppInput], opens a menu below the
/// field (or above when there's no room). Works standalone or in a [Form].
///
/// ```dart
/// AppDropdown<String>(
///   label: 'Select your gender',
///   hint: 'Choose from list',
///   value: gender,
///   items: const [
///     AppDropdownItem(value: 'f', label: 'Female'),
///     AppDropdownItem(value: 'm', label: 'Male'),
///   ],
///   onChanged: (v) => setState(() => gender = v),
/// )
/// ```
class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.validator,
    this.autovalidateMode,
    this.focusNode,
    this.menuMaxHeight = 300,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String? hint;

  /// Appends " *" to the label.
  final bool isRequired;
  final bool enabled;

  /// Forces an error message; overrides the [validator] result.
  final String? errorText;
  final String? helperText;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final double menuMaxHeight;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final _menu = MenuController();
  FocusNode? _ownFocusNode;
  bool _open = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  bool get _interactive => widget.enabled && widget.items.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_rebuild);
      if (widget.focusNode != null) {
        _ownFocusNode?.dispose();
        _ownFocusNode = null;
      }
      _focusNode.addListener(_rebuild);
    }
    if (!_interactive && _menu.isOpen) _menu.close();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_rebuild);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _toggle() => _menu.isOpen ? _menu.close() : _menu.open();

  @override
  Widget build(BuildContext context) {
    final colors = _FieldColors.of(context);
    final textStyle = AppTextStyles.subtitleS.medium;

    return _DropdownFormField<T>(
      initialValue: widget.value,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      builder: (field) {
        final error = widget.errorText ?? field.errorText;
        final selected = widget.items
            .where((item) => item.value == field.value)
            .firstOrNull;
        final textColor = !widget.enabled
            ? colors.disabledText
            : selected == null
            ? colors.hint
            : colors.text;

        return _FieldFrame(
          label: widget.label,
          isRequired: widget.isRequired,
          errorText: error,
          helperText: widget.helperText,
          child: LayoutBuilder(
            builder: (context, constraints) => MenuAnchor(
              controller: _menu,
              childFocusNode: _focusNode,
              alignmentOffset: const Offset(0, 6),
              consumeOutsideTap: true,
              onOpen: () => setState(() => _open = true),
              onClose: () => setState(() => _open = false),
              style: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(colors.menuBackground),
                surfaceTintColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                shadowColor: const WidgetStatePropertyAll(Color(0x1F636363)),
                elevation: const WidgetStatePropertyAll(6),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: _radius),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 8),
                ),
                minimumSize: WidgetStatePropertyAll(
                  Size(constraints.maxWidth, 0),
                ),
                maximumSize: WidgetStatePropertyAll(
                  Size(constraints.maxWidth, widget.menuMaxHeight),
                ),
              ),
              menuChildren: [
                for (final item in widget.items)
                  _option(
                    item,
                    colors: colors,
                    width: constraints.maxWidth,
                    isSelected: item == selected,
                    onPressed: () {
                      field.didChange(item.value);
                      widget.onChanged?.call(item.value);
                    },
                  ),
              ],
              builder: (context, menu, _) => Semantics(
                button: true,
                expanded: _open,
                value: selected?.label,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    focusNode: _focusNode,
                    canRequestFocus: _interactive,
                    onTap: _interactive ? _toggle : null,
                    borderRadius: _radius,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20 - _borderWidth,
                      ),
                      decoration: colors.decoration(
                        focused: _interactive && (_open || _focusNode.hasFocus),
                        hasError: error != null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selected?.label ?? widget.hint ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle.copyWith(color: textColor),
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: _open ? 0.5 : 0,
                            duration: const Duration(milliseconds: 150),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 24,
                              color: widget.enabled
                                  ? colors.icon
                                  : colors.disabledText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _option(
    AppDropdownItem<T> item, {
    required _FieldColors colors,
    required double width,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    final style = AppTextStyles.subtitleS.medium;
    return MenuItemButton(
      onPressed: item.enabled ? onPressed : null,
      trailingIcon: isSelected
          ? Icon(Icons.check_rounded, size: 20, color: colors.focusBorder)
          : null,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStatePropertyAll(Size(width, 44)),
        maximumSize: WidgetStatePropertyAll(Size(width, double.infinity)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        ),
        textStyle: WidgetStatePropertyAll(isSelected ? style.semiBold : style),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? colors.disabledText
              : isSelected
              ? colors.focusBorder
              : colors.text,
        ),
        overlayColor: WidgetStatePropertyAll(
          colors.focusBorder.withValues(alpha: 0.08),
        ),
      ),
      child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

/// [FormField] that adopts a new [initialValue] when the parent changes it,
/// so [AppDropdown.value] stays the source of truth.
class _DropdownFormField<T> extends FormField<T> {
  const _DropdownFormField({
    required super.builder,
    super.initialValue,
    super.validator,
    super.autovalidateMode,
    super.enabled,
  });

  @override
  FormFieldState<T> createState() => _DropdownFormFieldState<T>();
}

class _DropdownFormFieldState<T> extends FormFieldState<T> {
  @override
  void didUpdateWidget(_DropdownFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

/// Label above, [child] in the middle, error (or helper) text below.
class _FieldFrame extends StatelessWidget {
  const _FieldFrame({
    required this.child,
    this.label,
    this.isRequired = false,
    this.errorText,
    this.helperText,
  });

  final Widget child;
  final String? label;
  final bool isRequired;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final colors = _FieldColors.of(context);
    final message = errorText ?? helperText;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            isRequired ? '$label *' : label!,
            style: AppTextStyles.bodyS.semiBold.copyWith(color: colors.label),
          ),
          const SizedBox(height: 8),
        ],
        child,
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyS.medium.copyWith(
              color: errorText != null ? colors.error : colors.label,
            ),
          ),
        ],
      ],
    );
  }
}

/// Field colours, taken from the active [ColorScheme] so they follow
/// light and dark mode.
class _FieldColors {
  _FieldColors.of(BuildContext context) : this._(Theme.of(context).colorScheme);

  _FieldColors._(ColorScheme s)
    : fill = s.surfaceContainerHigh,
      focusedFill = s.surface,
      focusBorder = s.primary,
      text = s.onSurface,
      hint = s.onSurfaceVariant,
      label = s.onSurfaceVariant,
      disabledText = s.onSurface.withValues(alpha: 0.38),
      icon = s.primary,
      error = s.error,
      menuBackground = s.surface;

  final Color fill;
  final Color focusedFill;
  final Color focusBorder;
  final Color text;
  final Color hint;
  final Color label;
  final Color disabledText;
  final Color icon;
  final Color error;
  final Color menuBackground;

  BoxDecoration decoration({required bool focused, bool hasError = false}) {
    final accent = hasError ? error : focusBorder;
    return BoxDecoration(
      color: focused ? focusedFill : fill,
      borderRadius: _radius,
      border: Border.all(
        color: focused || hasError ? accent : Colors.transparent,
        width: _borderWidth,
      ),
      boxShadow: [
        if (focused)
          BoxShadow(
            color: accent.withValues(alpha: 0.25),
            spreadRadius: _borderWidth,
          ),
      ],
    );
  }
}

const _radius = BorderRadius.all(Radius.circular(8));
const _borderWidth = 1.5;
