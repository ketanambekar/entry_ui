import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:entry_ui/theme/app_text_styles.dart';
import 'package:entry_ui/widgets/app_toast.dart';

/// Copies [text] to the clipboard and confirms with a toast.
Future<void> copyToClipboard(String text, {String? label}) async {
  await Clipboard.setData(ClipboardData(text: text.trim()));
  AppToast.show(label == null ? 'Code copied to clipboard' : 'Copied $label');
}

class PlaygroundSection extends StatelessWidget {
  const PlaygroundSection(this.title, {super.key, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.caps.semiBold.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: children);
  }
}

/// Frames a demo and offers a "copy code" button with a ready-to-paste
/// snippet for that demo.
class CodeDemo extends StatelessWidget {
  const CodeDemo({
    super.key,
    required this.code,
    required this.child,
    this.title,
  });

  final String code;
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    style: AppTextStyles.bodyS.semiBold.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy code',
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  color: scheme.primary,
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () => copyToClipboard(code),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: child,
          ),
        ],
      ),
    );
  }
}
