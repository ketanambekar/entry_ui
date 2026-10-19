# {{project_name.titleCase()}}

{{{description}}}

UI comes from [entry_ui]({{{entry_ui_git_url}}}): `import 'package:entry_ui/entry_ui.dart';`.
The `/playground` route shows every widget with copy-ready code.
Run `flutter pub upgrade entry_ui` to pull the latest design system.

## Automatic versioning

The `version:` in `pubspec.yaml` (`major.minor.patch+build`) is bumped
automatically on every run/build:

- Every run or build increments **patch**.
- When patch reaches 100, **minor** is incremented and patch resets to 0.
- Only release **builds** also increment the **build** number (never `run`).

Use the wrapper instead of calling `flutter` directly:

```sh
./tool/flutter.sh run                # 1.0.0+1 -> 1.0.1+1
./tool/flutter.sh run --release      # 1.0.1+1 -> 1.0.2+1
./tool/flutter.sh build apk          # release by default -> 1.0.3+2
./tool/flutter.sh build apk --debug  # 1.0.3+2 -> 1.0.4+2
```

On Windows use `tool\flutter.bat`. The VS Code launch configurations in
`.vscode/launch.json` bump the version automatically via `preLaunchTask`.
To bump manually: `dart run tool/bump_version.dart [--release]`.
