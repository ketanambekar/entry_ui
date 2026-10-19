import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/widgets/app_button.dart';

/// Day / month / year wheel picker card with Cancel and Apply actions.
///
/// ```dart
/// final date = await AppDateWheelCard.show(
///   label: 'From',
///   initialDate: DateTime.now(),
///   firstDate: DateTime(2020),
///   lastDate: DateTime(2030),
/// );
/// ```
class AppDateWheelCard extends StatefulWidget {
  const AppDateWheelCard({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onApply,
    this.onCancel,
    this.label,
    this.applyLabel = 'Apply',
    this.cancelLabel = 'Cancel',
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onApply;
  final VoidCallback? onCancel;

  /// Header prefix, e.g. "From" → "From: 8 Feb 24".
  final String? label;
  final String applyLabel;
  final String cancelLabel;

  static Future<DateTime?> show({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String? label,
  }) {
    return Get.bottomSheet<DateTime>(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppDateWheelCard(
            label: label,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            onApply: (d) => Get.back(result: d),
            onCancel: Get.back,
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<AppDateWheelCard> createState() => _AppDateWheelCardState();
}

class _AppDateWheelCardState extends State<AppDateWheelCard> {
  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', //
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];
  static const _itemExtent = 58.0;

  late DateTime _date = _clamp(widget.initialDate);
  late final _day = FixedExtentScrollController(initialItem: _date.day - 1);
  late final _month = FixedExtentScrollController(initialItem: _date.month - 1);
  late final _year = FixedExtentScrollController(
    initialItem: _date.year - widget.firstDate.year,
  );

  DateTime _clamp(DateTime d) {
    final day = DateUtils.dateOnly(d);
    if (day.isBefore(widget.firstDate)) return widget.firstDate;
    if (day.isAfter(widget.lastDate)) return widget.lastDate;
    return day;
  }

  void _update({int? day, int? month, int? year}) {
    final y = year ?? _date.year;
    final m = month ?? _date.month;
    final maxDay = DateUtils.getDaysInMonth(y, m);
    final d = (day ?? _date.day).clamp(1, maxDay);
    final next = _clamp(DateTime(y, m, d));
    setState(() => _date = next);
    if (_day.selectedItem != next.day - 1) {
      _day.animateToItem(next.day - 1, duration: _anim, curve: Curves.easeOut);
    }
    if (_month.selectedItem != next.month - 1) {
      _month.animateToItem(
        next.month - 1,
        duration: _anim,
        curve: Curves.easeOut,
      );
    }
    final yi = next.year - widget.firstDate.year;
    if (_year.selectedItem != yi) {
      _year.animateToItem(yi, duration: _anim, curve: Curves.easeOut);
    }
  }

  static const _anim = Duration(milliseconds: 200);

  @override
  void dispose() {
    _day.dispose();
    _month.dispose();
    _year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final muted = dark ? AppDarkColors.grey200 : AppColors.grey200;
    final style = AppTextStyles.displayM.semiBold;
    final header =
        '${_date.day} ${_months[_date.month - 1][0]}'
        '${_months[_date.month - 1].substring(1).toLowerCase()} '
        '${(_date.year % 100).toString().padLeft(2, '0')}';

    Widget wheel({
      required FixedExtentScrollController controller,
      required int count,
      required String Function(int) text,
      required int selected,
      required ValueChanged<int> onChanged,
      required double width,
    }) {
      return SizedBox(
        width: width,
        height: _itemExtent * 3 - 24,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: _itemExtent,
          physics: const FixedExtentScrollPhysics(),
          perspective: 0.002,
          diameterRatio: 3,
          onSelectedItemChanged: onChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: count,
            builder: (_, i) => Center(
              child: Text(
                text(i),
                style: style.copyWith(
                  color: i == selected ? scheme.onSurface : muted,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label == null ? header : '${widget.label}: $header',
            style: AppTextStyles.subtitleM.medium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wheel(
                controller: _day,
                count: DateUtils.getDaysInMonth(_date.year, _date.month),
                text: (i) => '${i + 1}'.padLeft(2, '0'),
                selected: _date.day - 1,
                onChanged: (i) => _update(day: i + 1),
                width: 56,
              ),
              const SizedBox(width: 20),
              wheel(
                controller: _month,
                count: 12,
                text: (i) => _months[i],
                selected: _date.month - 1,
                onChanged: (i) => _update(month: i + 1),
                width: 84,
              ),
              const SizedBox(width: 20),
              wheel(
                controller: _year,
                count: widget.lastDate.year - widget.firstDate.year + 1,
                text: (i) => '${widget.firstDate.year + i}',
                selected: _date.year - widget.firstDate.year,
                onChanged: (i) => _update(year: widget.firstDate.year + i),
                width: 90,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: widget.cancelLabel,
                  variant: AppButtonVariant.secondary,
                  onPressed: widget.onCancel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: widget.applyLabel,
                  onPressed: () => widget.onApply(_date),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
