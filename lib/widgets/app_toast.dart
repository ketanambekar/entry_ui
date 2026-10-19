import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:entry_ui/theme/app_colors.dart';
import 'package:entry_ui/theme/app_text_styles.dart';

enum AppToastType { positive, negative }

/// Dark toast with a status icon and close button.
///
/// ```dart
/// AppToast.show('Entry saved');
/// AppToast.show('Something went wrong', type: AppToastType.negative);
/// ```
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.type = AppToastType.positive,
    this.onClose,
  });

  final String message;
  final AppToastType type;
  final VoidCallback? onClose;

  static void show(
    String message, {
    AppToastType type = AppToastType.positive,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        messageText: AppToast(
          message: message,
          type: type,
          onClose: Get.closeCurrentSnackbar,
        ),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark ? AppDarkColors.grey100 : AppColors.grey800;
    final foreground = dark ? AppDarkColors.grey800 : AppColors.grey25;
    final positive = type == AppToastType.positive;

    return Semantics(
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              positive ? Icons.check_circle_rounded : Icons.error_rounded,
              size: 24,
              color: positive
                  ? (dark ? AppDarkColors.success : AppColors.success)
                  : (dark ? AppDarkColors.error : AppColors.error),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyM.semiBold.copyWith(color: foreground),
              ),
            ),
            if (onClose != null) ...[
              const SizedBox(width: 10),
              IconButton(
                onPressed: onClose,
                tooltip: 'Dismiss',
                icon: const Icon(Icons.close_rounded),
                iconSize: 20,
                color: foreground,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 24,
                  height: 24,
                ),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
