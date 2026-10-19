import 'package:flutter/material.dart';

import 'package:{{project_name.snakeCase()}}/app/app.dart';

Future<void> main() async {
  await App.init();
  runApp(const App());
}
