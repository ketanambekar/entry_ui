import 'package:flutter/material.dart';

import 'package:entry_ui/theme/app_text_styles.dart';

/// Two-thumb range slider with min/max captions and optional value bubbles.
///
/// ```dart
/// AppRangeSlider(
///   min: 6,
///   max: 14,
///   values: range,
///   divisions: 8,
///   showValues: true,
///   format: (v) => '${v.round()}%',
///   onChanged: (r) => setState(() => range = r),
/// )
/// ```
class AppRangeSlider extends StatefulWidget {
  const AppRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.showValues = false,
    this.format,
    this.onChangeEnd,
  }) : assert(min < max);

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;
  final double min;
  final double max;

  /// Snaps values to this many equal steps.
  final int? divisions;

  /// Shows the current values in bubbles above the thumbs.
  final bool showValues;
  final String Function(double value)? format;

  @override
  State<AppRangeSlider> createState() => _AppRangeSliderState();
}

class _AppRangeSliderState extends State<AppRangeSlider> {
  static const _thumb = 28.0;
  bool? _draggingStart;

  bool get _enabled => widget.onChanged != null;
  double get _span => widget.max - widget.min;

  String _label(double v) =>
      widget.format?.call(v) ??
      (v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1));

  double _snap(double v) {
    v = v.clamp(widget.min, widget.max);
    final d = widget.divisions;
    if (d == null || d <= 0) return v;
    final step = _span / d;
    return widget.min + ((v - widget.min) / step).round() * step;
  }

  double get _step => widget.divisions != null && widget.divisions! > 0
      ? _span / widget.divisions!
      : _span / 20;

  void _update(bool start, double value) {
    final v = widget.values;
    final next = start
        ? RangeValues(_snap(value).clamp(widget.min, v.end), v.end)
        : RangeValues(v.start, _snap(value).clamp(v.start, widget.max));
    if (next != v) widget.onChanged?.call(next);
  }

  double _valueAt(double dx, double trackWidth) =>
      widget.min + ((dx - _thumb / 2) / trackWidth).clamp(0.0, 1.0) * _span;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final values = widget.values;
    final caption = AppTextStyles.bodyM.medium.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final track = constraints.maxWidth - _thumb;
        double x(double v) => (v - widget.min) / _span * track;
        final startX = x(values.start);
        final endX = x(values.end);

        void onDown(double dx) {
          final value = _valueAt(dx, track);
          _draggingStart =
              (value - values.start).abs() <= (value - values.end).abs() &&
              !(values.start == values.end && value > values.end);
          _update(_draggingStart!, value);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showValues)
              SizedBox(
                height: 41,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _bubble(startX, values.start, scheme, constraints),
                    _bubble(endX, values.end, scheme, constraints),
                  ],
                ),
              ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: _enabled
                  ? (d) => onDown(d.localPosition.dx)
                  : null,
              onHorizontalDragUpdate: _enabled
                  ? (d) => _update(
                      _draggingStart ?? true,
                      _valueAt(d.localPosition.dx, track),
                    )
                  : null,
              onHorizontalDragEnd: _enabled
                  ? (_) => widget.onChangeEnd?.call(widget.values)
                  : null,
              onTapDown: _enabled ? (d) => onDown(d.localPosition.dx) : null,
              onTapUp: _enabled
                  ? (_) => widget.onChangeEnd?.call(widget.values)
                  : null,
              child: SizedBox(
                height: _thumb,
                child: Stack(
                  children: [
                    Positioned(
                      left: _thumb / 2,
                      right: _thumb / 2,
                      top: 10,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Positioned(
                      left: _thumb / 2 + startX,
                      width: endX - startX,
                      top: 10,
                      height: 8,
                      child: ColoredBox(
                        color: _enabled ? scheme.primary : scheme.outline,
                      ),
                    ),
                    _thumbAt(startX, true, scheme),
                    _thumbAt(endX, false, scheme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _thumb / 2 - 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_label(widget.min), style: caption),
                  Text(_label(widget.max), style: caption),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _thumbAt(double left, bool start, ColorScheme scheme) {
    final v = widget.values;
    final value = start ? v.start : v.end;
    final lo = start ? widget.min : v.start;
    final hi = start ? v.end : widget.max;
    return Positioned(
      left: left,
      top: 0,
      child: Semantics(
        slider: true,
        label: start ? 'Minimum' : 'Maximum',
        value: _label(value),
        increasedValue: _label((value + _step).clamp(lo, hi)),
        decreasedValue: _label((value - _step).clamp(lo, hi)),
        onIncrease: _enabled ? () => _update(start, value + _step) : null,
        onDecrease: _enabled ? () => _update(start, value - _step) : null,
        child: Container(
          width: _thumb,
          height: _thumb,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: _enabled ? scheme.primary : scheme.outline,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 13,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 2),
                  Container(width: 1, height: 10, color: scheme.outlineVariant),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bubble(
    double left,
    double value,
    ColorScheme scheme,
    BoxConstraints constraints,
  ) {
    const width = 56.0;
    return Positioned(
      left: (left + _thumb / 2 - width / 2).clamp(
        0.0,
        constraints.maxWidth - width,
      ),
      top: 0,
      width: width,
      height: 33,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          _label(value),
          maxLines: 1,
          style: AppTextStyles.bodyS.semiBold.copyWith(color: scheme.onSurface),
        ),
      ),
    );
  }
}
