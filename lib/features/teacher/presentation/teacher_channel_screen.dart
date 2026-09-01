import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/shared/widgets/avatar.dart';

/// One mock channel message. Sender name and body are server-supplied Latin
/// content, so they are literal here rather than routed through [AppL10n].
class _ChannelMessage {
  const _ChannelMessage(this.sender, this.body);

  final String sender;
  final String body;
}

/// T09 — teacher class channel (docs/07). A read-only note strip, a short mock
/// message list and a flat composer. Sending is a mock — it reports itself as a
/// SnackBar.
class TeacherChannelScreen extends ConsumerWidget {
  const TeacherChannelScreen({super.key});

  static const _messages = <_ChannelMessage>[
    _ChannelMessage('Aziza Karimova', 'Ustoz, ertangi dars materiali qayerda?'),
    _ChannelMessage('Bekzod Aliyev', 'Rahmat!'),
  ];

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.tChannelTitle)),
      body: SafeArea(
        child: Column(
          children: [
            // Full-width read-only note strip.
            Container(
              width: double.infinity,
              color: colors.warningSubtle,
              padding: const EdgeInsets.symmetric(
                  horizontal: Space.gutter, vertical: Space.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: colors.warning),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      l.tChannelNote,
                      style: AppText.caption.copyWith(color: colors.warning),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    Space.gutter, Space.md, Space.gutter, Space.md),
                itemCount: _messages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: Space.md),
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar(name: message.sender, size: 32),
                      const SizedBox(width: Space.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.sender,
                              style: AppText.bodyStrong
                                  .copyWith(color: colors.textPrimary),
                            ),
                            Text(
                              message.body,
                              style: AppText.body
                                  .copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Composer. A hint would need its own l10n key, so it is left empty
            // rather than hardcoded — the send button carries the affordance.
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  top: BorderSide(color: colors.border, width: Stroke.hairline),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: Space.gutter, vertical: Space.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 4,
                      style: AppText.body.copyWith(color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: '',
                        isDense: true,
                        filled: true,
                        fillColor: colors.bg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Space.md, vertical: Space.sm),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.control),
                          borderSide: BorderSide(
                              color: colors.border, width: Stroke.hairline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.control),
                          borderSide: BorderSide(
                              color: colors.border, width: Stroke.hairline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.control),
                          borderSide: BorderSide(
                              color: colors.primary, width: Stroke.focus),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  IconButton(
                    onPressed: () => _toast(context, l.tChannelTitle),
                    icon: Icon(LucideIcons.send, color: colors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
