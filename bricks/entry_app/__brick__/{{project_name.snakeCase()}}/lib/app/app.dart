import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:entry_ui/entry_ui.dart';

import 'package:{{project_name.snakeCase()}}/app/bindings/app_binding.dart';
import 'package:{{project_name.snakeCase()}}/routes/app_pages.dart';
import 'package:{{project_name.snakeCase()}}/routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  /// Initialises storage and app-wide dependencies. Call before [runApp].
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    // Registered before the first frame so the saved ThemeMode is applied
    // immediately (initialBinding runs too late for that).
    AppBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '{{project_name.titleCase()}}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeController.to.themeMode,
      initialRoute: AppRoutes.initial,
      getPages: AppPages.pages,
    );
  }
}
