import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:sinfagram/core/localization/l10n/app_l10n.dart';
import 'package:sinfagram/core/theme/colors.dart';
import 'package:sinfagram/core/theme/gradients.dart';
import 'package:sinfagram/core/theme/spacing.dart';
import 'package:sinfagram/core/theme/typography.dart';
import 'package:sinfagram/features/auth/application/session_controller.dart';
import 'package:sinfagram/features/parent/application/parent_controllers.dart';
import 'package:sinfagram/shared/widgets/app_button.dart';
import 'package:sinfagram/shared/widgets/app_card.dart';
import 'package:sinfagram/shared/widgets/icon_tile.dart';

/// Parent "Men" — P04 controls + P05 consent & data (docs/07 §7.10). The data
/// screen states plainly what is and is not collected (docs/12 §12.1).
class ParentMeScreen extends ConsumerStatefulWidget {
  const ParentMeScreen({super.key});

  @override
  ConsumerState<ParentMeScreen> createState() => _ParentMeScreenState();
}

class _ParentMeScreenState extends ConsumerState<ParentMeScreen> {
  bool _notifs = true;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final colors = context.colors;
    final collected = ref.watch(collectedDataProvider);
    final notCollected = ref.watch(notCollectedDataProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(title: Text(l.navMe)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Space.gutter, Space.md, Space.gutter, Space.xxl),
          children: [
            _section(context, l.pControls),
            AppCard(
              child: Column(
                children: [
                  Row(children: [
                    const IconTile(LucideIcons.clock,
                        color: AppAccents.blue, size: 44),
                    const SizedBox(width: Space.md),
                    Expanded(
                        child: Text(l.pTimeLimit,
                            style: AppText.body
                                .copyWith(color: colors.textPrimary))),
                    Text(l.pMinutes(60),
                        style: AppText.numeric
                            .copyWith(color: colors.textSecondary)),
                  ]),
                  const Divider(height: Space.lg),
                  Row(children: [
                    const IconTile(LucideIcons.bell,
                        color: AppAccents.amber, size: 44),
                    const SizedBox(width: Space.md),
                    Expanded(
                        child: Text(l.pNotifs,
                            style: AppText.body
                                .copyWith(color: colors.textPrimary))),
                    Switch(
                        value: _notifs,
                        onChanged: (v) => setState(() => _notifs = v)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            _section(context, l.pConsentData),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(LucideIcons.circleCheck,
                        size: 24, color: colors.success),
                    const SizedBox(width: Space.sm),
                    Text(l.pConsentGranted,
                        style: AppText.bodyStrong
                            .copyWith(color: colors.textPrimary)),
                  ]),
                  const SizedBox(height: Space.md),
                  Text(l.pCollected,
                      style:
                          AppText.label.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: Space.xs),
                  for (final item in collected)
                    _dataRow(context, item, collected: true),
                  const SizedBox(height: Space.md),
                  Text(l.pNotCollected,
                      style:
                          AppText.label.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: Space.xs),
                  for (final item in notCollected)
                    _dataRow(context, item, collected: false),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            AppButton(l.pExport,
                variant: AppButtonVariant.secondary,
                icon: LucideIcons.download,
                onPressed: () => _toast(context, l.pExport)),
            const SizedBox(height: Space.sm),
            AppButton(l.pDelete,
                variant: AppButtonVariant.danger,
                icon: LucideIcons.trash2,
                onPressed: () => _toast(context, l.pDelete)),
            const SizedBox(height: Space.lg),
            _row(context, LucideIcons.settings, l.meSettings,
                () => context.push('/settings'),
                accent: AppAccents.cyan),
            const SizedBox(height: Space.sm),
            _row(context, LucideIcons.info, l.meAbout,
                () => context.push('/about'),
                accent: AppAccents.violet),
            const SizedBox(height: Space.sm),
            _row(context, LucideIcons.logOut, l.meSignOut,
                () => ref.read(sessionProvider.notifier).signOut(),
                danger: true),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Widget _section(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(bottom: Space.sm),
        child: Text(title.toUpperCase(),
            style: AppText.label.copyWith(
                color: context.colors.textTertiary, letterSpacing: 0.6)),
      );

  Widget _dataRow(BuildContext context, String text,
      {required bool collected}) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(collected ? LucideIcons.check : LucideIcons.x,
              size: 16,
              color: collected ? colors.success : colors.textTertiary),
          const SizedBox(width: Space.sm),
          Expanded(
              child: Text(text,
                  style: AppText.bodySm.copyWith(color: colors.textPrimary))),
        ],
      ),
    );
  }

  Widget _row(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool danger = false, Color? accent}) {
    final colors = context.colors;
    return AppCard(
      onTap: onTap,
      child: Row(children: [
        IconTile(icon,
            color: danger ? AppAccents.red : (accent ?? AppAccents.blue),
            size: 44),
        const SizedBox(width: Space.md),
        Expanded(
            child: Text(label,
                style: AppText.body.copyWith(
                    color: danger ? colors.danger : colors.textPrimary))),
        Icon(LucideIcons.chevronRight, size: 20, color: colors.textTertiary),
      ]),
    );
  }
}
