import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = (context.vars['project_name'] as String).snakeCase;
  final org = context.vars['org'] as String;
  final dir = Directory('${Directory.current.path}/$name');

  Future<void> flutter(List<String> args, String message) async {
    final progress = context.logger.progress(message);
    final result = await Process.run(
      'flutter',
      args,
      workingDirectory: dir.path,
      runInShell: true,
    );
    if (result.exitCode != 0) {
      progress.fail(message);
      context.logger.err('${result.stdout}\n${result.stderr}');
      exit(result.exitCode);
    }
    progress.complete();
  }

  await flutter([
    'create',
    '--org',
    org,
    '--project-name',
    name,
    '--platforms',
    'android,ios',
    '.',
  ], 'Adding android/ios platforms');

  final defaultTest = File('${dir.path}/test/widget_test.dart');
  if (defaultTest.existsSync()) defaultTest.deleteSync();
  final testDir = Directory('${dir.path}/test');
  if (testDir.existsSync() && testDir.listSync().isEmpty) testDir.deleteSync();
  for (final entity in dir.listSync()) {
    if (entity.path.endsWith('.iml') || entity.path.endsWith('/.idea')) {
      entity.deleteSync(recursive: true);
    }
  }

  await Process.run('chmod', ['+x', 'tool/flutter.sh'],
      workingDirectory: dir.path);
  await flutter(['pub', 'get'], 'Fetching packages');
  context.logger
      .success('Created $name. Open it and run ./tool/flutter.sh run');
}
