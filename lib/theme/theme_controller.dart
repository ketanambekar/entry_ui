import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Holds the app's [ThemeMode]. Defaults to [ThemeMode.system] and persists
/// the user's choice across restarts.
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  static const _storageKey = 'theme_mode';

  final _box = GetStorage();

  late final Rx<ThemeMode> _themeMode = _readSaved().obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode => switch (themeMode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => Get.isPlatformDarkMode,
  };

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _box.write(_storageKey, mode.name);
  }

  /// Switches between light and dark based on what is currently shown.
  void toggleTheme() =>
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);

  ThemeMode _readSaved() {
    final saved = _box.read<String>(_storageKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }
}
