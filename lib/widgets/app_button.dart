import 'dart:async';

import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_button_theme.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, tertiary, destructive, link }

/// Heights: compact 36, medium 44, large 52 (links: 25 / 29 / 29).
enum AppButtonSize { compact, medium, large }

/// The app's single button widget, covering every variant in the design
/// system. Colours come from [AppButtonTheme], so light/dark mode is automatic.
///
/// If [onPressed] returns a [Future], the button shows a loader and ignores
/// further taps until it completes. Pass `onPressed: null` to disable.
///
/// ```dart
/// AppButton(label: 'Save', onPressed: save)
/// AppButton(
///   label: 'Next',
///   variant: AppButtonVariant.secondary,
///   trailing: const Icon(Icons.arrow_forward),
///   expanded: true,
///   onPressed: next,
/// )
/// AppButton.icon(
///   icon: const Icon(Icons.delete_outline),
///   semanticLabel: 'Delete',
///   variant: AppButtonVariant.destructive,
///   onPressed: delete,
/// )
/// ```
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required String this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.leading,
    this.trailing,
    this.expanded = false,
    this.isLoading = false,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  }) : icon = null,
       semanticLabel = null;

  /// Square, icon-only button. [semanticLabel] is read by screen readers
  /// and also shown as a tooltip unless [tooltip] is given.
  const AppButton.icon({
    super.key,
    required Widget this.icon,
    required String this.semanticLabel,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  }) : label = null,
       leading = null,
       trailing = null,
       expanded = false;

  final String? label;
  final Widget? icon;
  final String? semanticLabel;
  final FutureOr<void> Function()? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Shown before / after the label. [Icon]s inherit the button's colour
  /// and size automatically.
  final Widget? leading;
  final Widget? trailing;

  /// Stretches to the available width (the "Full Width" design variant).
  final bool expanded;
  final bool isLoading;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _running = false;

  bool get _loading => widget.isLoading || _running;
  bool get _isLink => widget.variant == AppButtonVariant.link;
  bool get _iconOnly => widget.icon != null;

  Future<void> _handlePress() async {
    final result = widget.onPressed?.call();
    if (result is! Future) return;
    setState(() => _running = true);
    try {
      await result;
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppButtonTheme.of(context);
    final colors = switch (widget.variant) {
      AppButtonVariant.primary => theme.primary,
      AppButtonVariant.secondary => theme.secondary,
      AppButtonVariant.tertiary => theme.tertiary,
      AppButtonVariant.destructive => theme.destructive,
      AppButtonVariant.link => theme.link,
    };
    final metrics = _Metrics.of(widget.size, isLink: _isLink);
    final enabled = widget.onPressed != null && !_loading;

    // While loading the button is non-interactive but keeps its normal look.
    T resolve<T>(Set<WidgetState> states, T normal, T pressed, T disabled) {
      if (states.contains(WidgetState.disabled) && !_loading) return disabled;
      if (states.contains(WidgetState.pressed)) return pressed;
      return normal;
    }

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => resolve(
          s,
          colors.background,
          colors.pressedBackground,
          colors.disabledBackground,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => resolve(
          s,
          colors.foreground,
          colors.pressedForeground,
          colors.disabledForeground,
        ),
      ),
      iconColor: WidgetStateProperty.resolveWith(
        (s) => resolve(
          s,
          colors.foreground,
          colors.pressedForeground,
          colors.disabledForeground,
        ),
      ),
      side: colors.border == null
          ? null
          : WidgetStateProperty.resolveWith(
              (s) => BorderSide(
                color: resolve(
                  s,
                  colors.border!,
                  colors.pressedBorder ?? colors.border!,
                  colors.disabledBorder ?? colors.border!,
                ),
              ),
            ),
      // Pressed feedback comes from the state colours above; keep a subtle
      // overlay only for hover/focus (web, desktop, keyboard).
      overlayColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.hovered) || s.contains(WidgetState.focused)
            ? colors.foreground.withValues(alpha: 0.08)
            : Colors.transparent,
      ),
      splashFactory: NoSplash.splashFactory,
      textStyle: WidgetStatePropertyAll(metrics.textStyle),
      iconSize: WidgetStatePropertyAll(metrics.iconSize),
      padding: WidgetStatePropertyAll(
        _iconOnly ? EdgeInsets.zero : metrics.padding,
      ),
      minimumSize: WidgetStatePropertyAll(
        _iconOnly ? Size.square(metrics.height) : Size(0, metrics.height),
      ),
      maximumSize: WidgetStatePropertyAll(
        _iconOnly
            ? Size.square(metrics.height)
            : Size(double.infinity, metrics.height),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(_radius)),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      mouseCursor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled)
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
      ),
      animationDuration: const Duration(milliseconds: 120),
    );

    final loader = SizedBox.square(
      dimension: metrics.iconSize * 0.75,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: colors.foreground,
      ),
    );

    Widget child;
    if (_iconOnly) {
      child = _loading ? loader : widget.icon!;
    } else {
      final leading = _loading ? loader : widget.leading;
      child = Row(
        mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading, SizedBox(width: metrics.gap)],
          Flexible(
            child: Text(
              widget.label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          if (widget.trailing != null) ...[
            SizedBox(width: metrics.gap),
            widget.trailing!,
          ],
        ],
      );
    }

    Widget button = TextButton(
      onPressed: enabled ? _handlePress : null,
      style: style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: child,
    );

    if (_iconOnly) {
      button = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: enabled,
        excludeSemantics: true,
        child: button,
      );
    }

    final tooltip = widget.tooltip ?? widget.semanticLabel;
    if (tooltip != null) button = Tooltip(message: tooltip, child: button);

    if (widget.expanded && !_isLink) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return Semantics(liveRegion: _loading, child: button);
  }
}

const _radius = Radius.circular(8);

/// Sizing from the design spec.
class _Metrics {
  const _Metrics({
    required this.height,
    required this.padding,
    required this.gap,
    required this.iconSize,
    required this.textStyle,
  });

  final double height;
  final EdgeInsets padding;
  final double gap;
  final double iconSize;
  final TextStyle textStyle;

  static _Metrics of(AppButtonSize size, {required bool isLink}) {
    if (isLink) {
      return size == AppButtonSize.compact
          ? _Metrics(
              height: 25,
              padding: const EdgeInsets.all(4),
              gap: 4,
              iconSize: 16,
              textStyle: AppTextStyles.bodyM.semiBold,
            )
          : _Metrics(
              height: 29,
              padding: const EdgeInsets.all(4),
              gap: 4,
              iconSize: 18,
              textStyle: AppTextStyles.subtitleXS.semiBold,
            );
    }
    return switch (size) {
      AppButtonSize.compact => _Metrics(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        gap: 4,
        iconSize: 20,
        textStyle: AppTextStyles.bodyL.semiBold,
      ),
      AppButtonSize.medium => _Metrics(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        gap: 8,
        iconSize: 24,
        textStyle: AppTextStyles.subtitleXS.semiBold,
      ),
      AppButtonSize.large => _Metrics(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        gap: 8,
        iconSize: 24,
        textStyle: AppTextStyles.subtitleXS.semiBold,
      ),
    };
  }
}
