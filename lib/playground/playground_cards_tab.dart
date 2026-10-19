import 'package:flutter/material.dart';

import 'package:entry_ui/playground/playground_kit.dart';
import 'package:entry_ui/widgets/app_alert_card.dart';
import 'package:entry_ui/widgets/app_button.dart';
import 'package:entry_ui/widgets/app_date_wheel_card.dart';
import 'package:entry_ui/widgets/app_disclaimer.dart';
import 'package:entry_ui/widgets/app_fact_card.dart';
import 'package:entry_ui/widgets/app_mini_card.dart';
import 'package:entry_ui/widgets/app_note_card.dart';
import 'package:entry_ui/widgets/app_overview_card.dart';
import 'package:entry_ui/widgets/app_selection_card.dart';
import 'package:entry_ui/widgets/app_status_card.dart';
import 'package:entry_ui/widgets/app_tag.dart';
import 'package:entry_ui/widgets/app_toast.dart';
import 'package:entry_ui/widgets/app_upload_card.dart';

class PlaygroundCardsTab extends StatefulWidget {
  const PlaygroundCardsTab({super.key});

  @override
  State<PlaygroundCardsTab> createState() => _PlaygroundCardsTabState();
}

class _PlaygroundCardsTabState extends State<PlaygroundCardsTab> {
  String _source = 'camera';
  String _plan = 'monthly';
  bool _uploaded = false;
  bool _tooBig = false;
  DateTime _date = DateTime(2024, 2, 8);

  static const _statuses = [
    ('PAYMENT DONE', AppTagTone.success),
    ('PARTIALLY EXECUTED (2/5)', AppTagTone.caution),
    ('EXECUTION PENDING', AppTagTone.warning),
    ('MODIFIED & EXECUTION PENDING', AppTagTone.error),
    ('TRANSFER IN PROGRESS', AppTagTone.purple),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final page = Theme.of(context).scaffoldBackgroundColor;
    final grey = scheme.surfaceContainerHigh;

    Widget onGrey(Widget child) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );

    return PlaygroundPage(
      children: [
        PlaygroundSection(
          'AppMiniCard',
          children: [
            CodeDemo(
              code: '''
const AppMiniCard(label: '100%')
const AppMiniCard.icon(icon: Icons.badge_outlined, label: 'ID card')''',
              child: onGrey(
                const Row(
                  children: [
                    AppMiniCard(label: '100%'),
                    SizedBox(width: 12),
                    AppMiniCard.icon(
                      icon: Icons.badge_outlined,
                      label: 'ID card',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppNoteCard & AppDisclaimer',
          children: [
            CodeDemo(
              code: '''
const AppNoteCard(
  message: 'This information is encrypted and used only for your records.',
)

const AppDisclaimer('By tapping Continue you agree to our terms of use.')''',
              child: const Column(
                children: [
                  AppNoteCard(
                    message:
                        'This information is strictly confidential and '
                        'encrypted. It is used only for your records.',
                  ),
                  SizedBox(height: 12),
                  AppDisclaimer(
                    'By tapping Confirm and Continue below, I consent to '
                    'share my details for verification. Please allow pop-ups '
                    'for this app in settings.',
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppOverviewCard',
          children: [
            CodeDemo(
              code: '''
AppOverviewCard(
  title: 'Overview',
  items: const [
    AppOverviewItem('Category', 'Groceries'),
    AppOverviewItem('Amount', '₹1,250'),
    AppOverviewItem('Paid via', 'UPI'),
    AppOverviewItem('Date', '24 Jun 24'),
  ],
)''',
              child: const AppOverviewCard(
                title: 'Overview',
                items: [
                  AppOverviewItem('Category', 'Groceries'),
                  AppOverviewItem('Paid via', 'UPI'),
                  AppOverviewItem('Account', 'HDFC ••42'),
                  AppOverviewItem('Status', 'Cleared'),
                  AppOverviewItem('Amount', '₹1,250'),
                  AppOverviewItem('Date', '24 Jun 24'),
                  AppOverviewItem('Time', '05:45 pm'),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppFactCard',
          children: [
            CodeDemo(
              code: '''
const AppFactCard(
  title: 'Did you know?',
  message: 'Tracking daily expenses can cut spending by up to 15%.',
)''',
              child: const AppFactCard(
                title: 'Did you know?',
                message:
                    'Tracking daily expenses can cut monthly spending by up '
                    'to 15%.',
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppAlertCard',
          children: [
            CodeDemo(
              code: '''
AppAlertCard(
  title: 'Incorrect details entered?',
  action: AppButton(
    label: 'Contact us',
    variant: AppButtonVariant.tertiary,
    size: AppButtonSize.compact,
    leading: const Icon(Icons.phone_outlined),
    onPressed: contactSupport,
  ),
)''',
              child: AppAlertCard(
                title: 'Incorrect details entered?',
                action: AppButton(
                  label: 'Contact us',
                  variant: AppButtonVariant.tertiary,
                  size: AppButtonSize.compact,
                  leading: const Icon(Icons.phone_outlined),
                  onPressed: () => AppToast.show('Calling support…'),
                ),
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppUploadCard',
          children: [
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Uploaded'),
                    value: _uploaded,
                    onChanged: (v) => setState(() => _uploaded = v),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Too big'),
                    value: _tooBig,
                    onChanged: _uploaded
                        ? (v) => setState(() => _tooBig = v)
                        : null,
                  ),
                ),
              ],
            ),
            CodeDemo(
              code: '''
AppUploadCard(
  preview: file == null ? null : Image.file(file!, fit: BoxFit.cover),
  errorText: tooBig ? 'Please upload a file smaller than 10 MB.' : null,
  onUpload: pickFile,
)''',
              child: AppUploadCard(
                onUpload: () => setState(() => _uploaded = true),
                preview: _uploaded
                    ? Container(
                        color: scheme.primaryContainer,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.draw_outlined,
                          size: 64,
                          color: scheme.primary,
                        ),
                      )
                    : null,
                errorText: _uploaded && _tooBig
                    ? 'Please upload a file smaller than 10 MB.'
                    : null,
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppSelectionCard',
          children: [
            CodeDemo(
              title: 'With icon',
              code: '''
AppSelectionCard<String>(
  value: 'camera',
  groupValue: source,
  icon: Icons.photo_camera_outlined,
  title: 'Camera',
  description: 'Take a new photo',
  onChanged: (v) => setState(() => source = v),
)''',
              child: Row(
                children: [
                  Expanded(
                    child: AppSelectionCard<String>(
                      value: 'camera',
                      groupValue: _source,
                      icon: Icons.photo_camera_outlined,
                      title: 'Camera',
                      description: 'Take a new photo',
                      onChanged: (v) => setState(() => _source = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppSelectionCard<String>(
                      value: 'gallery',
                      groupValue: _source,
                      icon: Icons.photo_library_outlined,
                      title: 'Gallery',
                      description: 'Pick from photos',
                      onChanged: (v) => setState(() => _source = v),
                    ),
                  ),
                ],
              ),
            ),
            CodeDemo(
              title: 'Without icon',
              code: '''
AppSelectionCard<String>(
  value: 'monthly',
  groupValue: plan,
  title: 'Monthly',
  onChanged: (v) => setState(() => plan = v),
)''',
              child: Row(
                children: [
                  for (final (i, p) in ['monthly', 'yearly'].indexed) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: AppSelectionCard<String>(
                        value: p,
                        groupValue: _plan,
                        title: p == 'monthly' ? 'Monthly' : 'Yearly',
                        onChanged: (v) => setState(() => _plan = v),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppDateWheelCard',
          children: [
            CodeDemo(
              code: '''
final date = await AppDateWheelCard.show(
  label: 'From',
  initialDate: from,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);
if (date != null) setState(() => from = date);''',
              child: Column(
                children: [
                  Container(
                    color: page,
                    child: AppDateWheelCard(
                      label: 'From',
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030, 12, 31),
                      onApply: (d) {
                        setState(() => _date = d);
                        AppToast.show('Applied ${d.day}/${d.month}/${d.year}');
                      },
                      onCancel: () =>
                          setState(() => _date = DateTime(2024, 2, 8)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Open as bottom sheet',
                    variant: AppButtonVariant.tertiary,
                    expanded: true,
                    onPressed: () async {
                      final d = await AppDateWheelCard.show(
                        label: 'To',
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030, 12, 31),
                      );
                      if (d != null) setState(() => _date = d);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        PlaygroundSection(
          'AppStatusCard',
          children: [
            CodeDemo(
              code: '''
AppStatusCard(
  status: 'PAYMENT DONE',
  tone: AppTagTone.success,
  title: 'Monthly rent',
  subtitle: 'TXN-000123',
  leading: const Icon(Icons.home_outlined),
  tags: const [
    AppTag('PAID', tone: AppTagTone.success),
    AppTag('UPI', style: AppTagStyle.outlined, tone: AppTagTone.purple),
  ],
  trailing: '1 Qty',
  stats: const [
    [AppStat('Amount', '₹20,000'), AppStat('Due', '05 Jul')],
    [
      AppStat('Entry ID', 'EB-10293', emphasize: false),
      AppStat('Date', '24 Jun 24', emphasize: false),
    ],
  ],
  actions: [
    AppButton(
      label: 'Receipt',
      variant: AppButtonVariant.tertiary,
      size: AppButtonSize.compact,
      leading: const Icon(Icons.download_rounded),
      onPressed: downloadReceipt,
    ),
  ],
)

// Cancelled with a reason
AppStatusCard(
  status: 'CANCELLED',
  tone: AppTagTone.error,
  title: 'Electricity bill',
  note: 'Reason: payment expired before confirmation.',
)''',
              child: Column(
                children: [
                  for (final (status, tone) in _statuses) ...[
                    _demoStatus(status, tone),
                    const SizedBox(height: 12),
                  ],
                  _demoStatus(
                    'CANCELLED',
                    AppTagTone.error,
                    note:
                        'Reason for cancellation: the payment expired before '
                        'it was confirmed.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _demoStatus(String status, AppTagTone tone, {String? note}) {
    final scheme = Theme.of(context).colorScheme;
    return AppStatusCard(
      status: status,
      tone: tone,
      title: 'Monthly rent',
      subtitle: 'TXN-000123',
      leading: Icon(Icons.home_outlined, color: scheme.primary),
      tags: const [
        AppTag('PAID', tone: AppTagTone.success),
        AppTag('UPI', style: AppTagStyle.outlined, tone: AppTagTone.purple),
        AppTag('RENT', style: AppTagStyle.outlined, tone: AppTagTone.purple),
      ],
      trailing: '3 Qty',
      stats: [
        [
          const AppStat('Amount', '₹20,200'),
          AppStat('Interest', '4.56%', color: scheme.primary),
          const AppStat('Per unit', '₹703.21'),
        ],
        const [
          AppStat('Entry ID', 'EB-10293', emphasize: false),
          AppStat('Date', '24 Jun 24', emphasize: false),
          AppStat('Time', '05:45 pm', emphasize: false),
        ],
      ],
      note: note,
      actions: note != null
          ? const []
          : [
              if (tone == AppTagTone.error) ...[
                AppButton.icon(
                  icon: const Icon(Icons.delete_outline_rounded),
                  semanticLabel: 'Delete',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.compact,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Modify',
                  size: AppButtonSize.compact,
                  leading: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                ),
              ] else
                AppButton(
                  label: 'Receipt',
                  variant: AppButtonVariant.tertiary,
                  size: AppButtonSize.compact,
                  leading: const Icon(Icons.download_rounded),
                  onPressed: () {},
                ),
            ],
    );
  }
}
