# entry_ui

Shared design system for Entry apps: light/dark theme, fonts (Manrope, Banana
Grotesk), colours, text styles, `AppIcons`, all reusable widgets and the
playground screen. Also contains the `entry_app` Mason brick that creates a new
app wired to this package.

## Use in an existing app

```yaml
dependencies:
  get: ^4.7.3
  get_storage: ^2.1.1
  entry_ui:
    git:
      url: https://github.com/ketanambekar/entry_ui.git
      ref: main
```

```dart
import 'package:entry_ui/entry_ui.dart';

GetMaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeController.to.themeMode,
  getPages: [GetPage(name: '/playground', page: () => const PlaygroundView())],
);
```

Call `await GetStorage.init()` and `Get.put(ThemeController(), permanent: true)`
before `runApp`. Fonts are bundled; nothing to add to the app's pubspec.

Pull updates with `flutter pub upgrade entry_ui`.

## Create a new app

One-time setup:

```sh
dart pub global activate mason_cli
mason add -g entry_app --git-url https://github.com/ketanambekar/entry_ui.git --git-path bricks/entry_app
```

Then for each new app:

```sh
mason make entry_app
```

It asks for the app name, description, org (bundle id prefix) and the entry_ui
git URL/ref, then generates the GetX shell (app, bindings, routes, playground
route), version-bump tooling, VS Code launch configs, `.gitignore`, lint rules
and the android/ios folders, and runs `flutter pub get`.

## Develop

- Add or change widgets in `lib/widgets`, export them from `lib/entry_ui.dart`
  and add a `CodeDemo` to the playground.
- Imports must use `package:entry_ui/...`.
- Tag releases (`git tag v1.1.0`) so apps can pin `ref: v1.1.0`.
