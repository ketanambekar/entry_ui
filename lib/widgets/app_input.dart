import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Design-system text field: label, filled box with focus ring, and an
/// error/helper line. Works standalone or inside a [Form] via [validator].
///
/// ```dart
/// AppInput(label: 'User ID', hint: 'eg. kevinabc', isRequired: true)
/// AppInput(label: 'Password', obscureText: true, validator: ...)
/// ```
class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.errorText,
    this.helperText,
    this.validator,
    this.autovalidateMode,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  }) : assert(
         controller == null || initialValue == null,
         'Provide either a controller or an initialValue, not both.',
       );

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;

  /// Appends " *" to the label.
  final bool isRequired;
  final bool enabled;
  final bool readOnly;

  /// Hides the text and adds a show/hide toggle (unless [suffixIcon] is set).
  final bool obscureText;

  /// Forces an error message; overrides the [validator] result.
  final String? errorText;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  late String _initialText;
  late bool _obscured = widget.obscureText;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownController ??= TextEditingController(text: widget.initialValue));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _initialText = _controller.text;
    _controller.addListener(_syncFormValue);
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(AppInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_syncFormValue);
      if (widget.controller != null) {
        _ownController?.dispose();
        _ownController = null;
      }
      _controller.addListener(_syncFormValue);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_rebuild);
      if (widget.focusNode != null) {
        _ownFocusNode?.dispose();
        _ownFocusNode = null;
      }
      _focusNode.addListener(_rebuild);
    }
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFormValue);
    _focusNode.removeListener(_rebuild);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _syncFormValue() {
    final field = _fieldKey.currentState;
    if (field != null && field.value != _controller.text) {
      field.didChange(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _FieldColors.of(context);
    final enabled = widget.enabled;
    final multiline = widget.maxLines != 1;
    final iconColor = enabled ? colors.icon : colors.disabledText;
    final textStyle = AppTextStyles.subtitleS.medium;

    return _TextControllerFormField(
      key: _fieldKey,
      controller: _controller,
      initialValue: _initialText,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: enabled,
      builder: (field) {
        final error = widget.errorText ?? field.errorText;
        final suffix =
            widget.suffixIcon ??
            (widget.obscureText ? _visibilityToggle(iconColor) : null);

        return _FieldFrame(
          label: widget.label,
          isRequired: widget.isRequired,
          errorText: error,
          helperText: widget.helperText,
          child: GestureDetector(
            onTap: enabled ? _focusNode.requestFocus : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(
                horizontal: 20 - _borderWidth,
                vertical: 13 - _borderWidth,
              ),
              decoration: colors.decoration(
                focused: enabled && _focusNode.hasFocus,
                hasError: error != null,
              ),
              child: IconTheme(
                data: IconThemeData(color: iconColor, size: 24),
                child: Row(
                  crossAxisAlignment: multiline
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    if (widget.prefixIcon != null) ...[
                      widget.prefixIcon!,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: enabled,
                        readOnly: widget.readOnly,
                        obscureText: _obscured,
                        autofocus: widget.autofocus,
                        keyboardType:
                            widget.keyboardType ??
                            (multiline ? TextInputType.multiline : null),
                        textInputAction: widget.textInputAction,
                        textCapitalization: widget.textCapitalization,
                        inputFormatters: widget.inputFormatters,
                        autofillHints: enabled ? widget.autofillHints : null,
                        maxLength: widget.maxLength,
                        maxLines: _obscured ? 1 : widget.maxLines,
                        minLines: _obscured ? null : widget.minLines,
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        onTap: widget.onTap,
                        style: textStyle.copyWith(
                          color: enabled ? colors.text : colors.disabledText,
                        ),
                        cursorColor: error != null
                            ? colors.error
                            : colors.focusBorder,
                        buildCounter:
                            (
                              _, {
                              required currentLength,
                              required isFocused,
                              maxLength,
                            }) => null,
                        decoration: InputDecoration.collapsed(
                          hintText: widget.hint,
                          hintStyle: textStyle.copyWith(
                            color: enabled ? colors.hint : colors.disabledText,
                          ),
                        ),
                      ),
                    ),
                    if (suffix != null) ...[const SizedBox(width: 4), suffix],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _visibilityToggle(Color color) {
    return IconButton(
      onPressed: widget.enabled
          ? () => setState(() => _obscured = !_obscured)
          : null,
      tooltip: _obscured ? 'Show' : 'Hide',
      icon: Icon(
        _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
      color: color,
      disabledColor: color,
      iconSize: 24,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
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

/// [FormField] bound to a [TextEditingController]: the form value follows the
/// controller, and [FormState.reset] restores the controller's initial text.
class _TextControllerFormField extends FormField<String> {
  const _TextControllerFormField({
    super.key,
    required this.controller,
    required super.builder,
    super.initialValue,
    super.validator,
    super.autovalidateMode,
    super.enabled,
  });

  final TextEditingController controller;

  @override
  FormFieldState<String> createState() => _TextControllerFormFieldState();
}

class _TextControllerFormFieldState extends FormFieldState<String> {
  _TextControllerFormField get _field => widget as _TextControllerFormField;

  @override
  void initState() {
    super.initState();
    setValue(_field.controller.text);
  }

  @override
  void didUpdateWidget(_TextControllerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != _field.controller) {
      setValue(_field.controller.text);
    }
  }

  @override
  void reset() {
    _field.controller.text = widget.initialValue ?? '';
    super.reset();
  }
}
