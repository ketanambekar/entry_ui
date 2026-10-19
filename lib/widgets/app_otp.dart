import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Design-system OTP / PIN input: one box per character, backed by a single
/// hidden text field so paste, SMS autofill and backspace work natively.
///
/// ```dart
/// AppOtp(onCompleted: (code) => controller.verify(code))
/// AppOtp(length: 6, secure: true)
/// ```
class AppOtp extends StatefulWidget {
  const AppOtp({
    super.key,
    this.length = 4,
    this.controller,
    this.focusNode,
    this.secure = false,
    this.digitsOnly = true,
    this.enabled = true,
    this.autofocus = false,
    this.label,
    this.isRequired = false,
    this.errorText,
    this.helperText,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onCompleted,
  }) : assert(length > 0);

  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Shows dots instead of characters (PIN entry).
  final bool secure;
  final bool digitsOnly;
  final bool enabled;
  final bool autofocus;
  final String? label;
  final bool isRequired;

  /// Forces an error message; overrides the [validator] result.
  final String? errorText;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  /// Called when every box is filled.
  final ValueChanged<String>? onCompleted;

  @override
  State<AppOtp> createState() => _AppOtpState();
}

class _AppOtpState extends State<AppOtp> {
  static const _gap = 8.0;
  static const _boxWidth = 56.0;
  static const _boxHeight = 66.0;

  final _fieldKey = GlobalKey<FormFieldState<String>>();
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  late String _initialText;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _initialText = _controller.text;
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(AppOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_onTextChanged);
      if (widget.controller != null) {
        _ownController?.dispose();
        _ownController = null;
      }
      _controller.addListener(_onTextChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_rebuild);
      if (widget.focusNode != null) {
        _ownFocusNode?.dispose();
        _ownFocusNode = null;
      }
      _focusNode.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_rebuild);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _onTextChanged() {
    // Typing always happens at the end; taps must not move the caret.
    final text = _controller.text;
    final end = TextSelection.collapsed(offset: text.length);
    if (_controller.selection != end) _controller.selection = end;

    final field = _fieldKey.currentState;
    if (field != null && field.value != text) field.didChange(text);
    if (mounted) setState(() {});
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _FieldColors.of(context);

    return _TextControllerFormField(
      key: _fieldKey,
      controller: _controller,
      initialValue: _initialText,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      builder: (field) {
        final error = widget.errorText ?? field.errorText;
        return _FieldFrame(
          label: widget.label,
          isRequired: widget.isRequired,
          errorText: error,
          helperText: widget.helperText,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = math.min(
                _boxWidth,
                (constraints.maxWidth - _gap * (widget.length - 1)) /
                    widget.length,
              );
              return Align(
                alignment: AlignmentDirectional.centerStart,
                child: SizedBox(
                  width: boxWidth * widget.length + _gap * (widget.length - 1),
                  height: _boxHeight,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          for (var i = 0; i < widget.length; i++) ...[
                            if (i > 0) const SizedBox(width: _gap),
                            _box(i, boxWidth, colors, hasError: error != null),
                          ],
                        ],
                      ),
                      Positioned.fill(child: _hiddenField()),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _hiddenField() {
    return Opacity(
      opacity: 0,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        obscureText: widget.secure,
        keyboardType: widget.digitsOnly
            ? TextInputType.number
            : TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        autofillHints: widget.enabled
            ? const [AutofillHints.oneTimeCode]
            : null,
        autocorrect: false,
        enableSuggestions: false,
        enableInteractiveSelection: false,
        showCursor: false,
        inputFormatters: [
          if (widget.digitsOnly) FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.length),
        ],
        onChanged: _onChanged,
        decoration: const InputDecoration.collapsed(hintText: null),
      ),
    );
  }

  Widget _box(
    int index,
    double width,
    _FieldColors colors, {
    required bool hasError,
  }) {
    final text = _controller.text;
    final char = index < text.length ? text[index] : null;
    final current = math.min(text.length, widget.length - 1);
    final focused = widget.enabled && _focusNode.hasFocus && index == current;
    final color = widget.enabled ? colors.text : colors.disabledText;

    final Widget? content;
    if (char == null) {
      content = focused
          ? Container(
              width: 1.5,
              height: 24,
              color: hasError ? colors.error : colors.focusBorder,
            )
          : null;
    } else if (widget.secure) {
      content = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
    } else {
      content = Text(
        char,
        style: AppTextStyles.displayS.medium.copyWith(color: color),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: _boxHeight,
      alignment: Alignment.center,
      decoration: colors.decoration(focused: focused, hasError: hasError),
      child: content,
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
